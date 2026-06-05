import 'dart:async';
import 'dart:developer';

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

/// Manages the courier SignalR hub: location updates + real-time order events.
///
/// Call [start] when opening the courier screen, [stop] when leaving.
/// The hub is shared for both geolocation (UpdateMyLocation) and orders
/// (MyOrders / OrderAssigned / OrderDelivered). No REST polling needed.
@lazySingleton
class CourierLocationHubService {
  CourierLocationHubService(this._prefs);

  final SharedPreferences _prefs;
  HubManager? _hub;
  Timer? _locationTimer;
  Timer? _restartTimer;
  bool _isActive = false;
  bool _currentShiftState = false;

  final _myOrdersController = StreamController<List<CurierEntity>>.broadcast();
  final _orderAssignedController = StreamController<CurierEntity>.broadcast();
  final _orderDeliveredController = StreamController<int>.broadcast();

  /// Snapshot of current orders — arrives after [requestOrders] is called.
  Stream<List<CurierEntity>> get ordersStream => _myOrdersController.stream;

  /// Pushed by the server when dispatcher assigns a new order to this courier.
  Stream<CurierEntity> get orderAssignedStream => _orderAssignedController.stream;

  /// Pushed by the server after courier finishes delivery via REST.
  Stream<int> get orderDeliveredStream => _orderDeliveredController.stream;

  static const _locationInterval = Duration(seconds: 2);
  static const _restartDelay = Duration(seconds: 5);

  Future<void> start() async {
    _isActive = true;
    if (_hub != null) return;

    _restartTimer?.cancel();
    _restartTimer = null;

    final token = _prefs.getString(AppConst.accessToken);
    if (token == null || token.isEmpty) {
      log('[CourierLocationHub] No access token, skip start');
      return;
    }

    try {
      _hub = HubManager(
        config: HubConnectionConfig(
          hubUrl: ApiConst.courierLocationHubUrl,
          accessToken: token,
          skipNegotiation: true,
          reconnectIntervals: const [2000, 5000, 10000],
          loggerName: 'CourierLocationHub',
        ),
        onClosed: _onConnectionClosed,
        onReconnected: _onHubReconnected,
      );

      _hub!.on('MyOrders', _onMyOrders);
      _hub!.on('OrderAssigned', _onOrderAssigned);
      _hub!.on('OrderDelivered', _onOrderDelivered);
      _hub!.on('RequestShiftConfirm', _onRequestShiftConfirm);
      _hub!.on('ShiftStatus', _onShiftStatus);

      await _hub!.start();

      _locationTimer = Timer.periodic(_locationInterval, (_) => _sendLocation());
      _sendLocation();

      // Restore shift state on (re)connect and pull the current order list.
      _currentShiftState = _prefs.getBool(AppConst.courierOnShift) ?? true;
      await _invokeSetOnShift(_currentShiftState);
      await _invokeRequestOrders();
    } catch (e) {
      log('[CourierLocationHub] Start error: $e');
      _hub = null;
      _scheduleRestart();
    }
  }

  /// Notify the hub about a shift-state change.
  /// Call this alongside the REST shift endpoint so the server reflects the
  /// correct state even before any reconnect.
  Future<void> setOnShift(bool onShift) async {
    _currentShiftState = onShift;
    await _invokeSetOnShift(onShift);
  }

  /// Explicitly request the current order snapshot (e.g. on manual refresh).
  Future<void> requestOrders() async => _invokeRequestOrders();

  // ─── Private helpers ───────────────────────────────────────────────────────

  Future<void> _onHubReconnected() async {
    log('[CourierLocationHub] Reconnected — restoring shift=$_currentShiftState, restarting timer if needed');
    // SignalR groups reset on reconnect — must re-register.
    _locationTimer ??= Timer.periodic(_locationInterval, (_) => _sendLocation());
    await _invokeSetOnShift(_currentShiftState);
    await _invokeRequestOrders();
  }

  Future<void> _invokeSetOnShift(bool onShift) async {
    try {
      await _hub?.invoke('SetOnShift', args: [onShift]);
    } catch (e) {
      log('[CourierLocationHub] SetOnShift error: $e');
    }
  }

  Future<void> _invokeRequestOrders() async {
    try {
      await _hub?.invoke('RequestMyOrders');
    } catch (e) {
      log('[CourierLocationHub] RequestMyOrders error: $e');
    }
  }

  void _onMyOrders(List<Object?>? args) {
    if (args == null || args.isEmpty || args[0] == null) return;
    try {
      final orders = (args[0] as List)
          .map((e) => CurierOrderModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .map((m) => m.toEntity())
          .toList();
      _myOrdersController.add(orders);
    } catch (e) {
      log('[CourierLocationHub] MyOrders parse error: $e');
    }
  }

  void _onOrderAssigned(List<Object?>? args) {
    if (args == null || args.isEmpty || args[0] == null) return;
    try {
      final order = CurierOrderModel.fromJson(
        Map<String, dynamic>.from(args[0] as Map),
      ).toEntity();
      _orderAssignedController.add(order);
    } catch (e) {
      log('[CourierLocationHub] OrderAssigned parse error: $e');
    }
  }

  void _onOrderDelivered(List<Object?>? args) {
    if (args == null || args.isEmpty || args[0] == null) return;
    try {
      _orderDeliveredController.add((args[0] as num).toInt());
    } catch (e) {
      log('[CourierLocationHub] OrderDelivered parse error: $e');
    }
  }

  void _onRequestShiftConfirm(List<Object?>? _) {
    _invokeSetOnShift(_currentShiftState);
  }

  void _onShiftStatus(List<Object?>? args) {
    if (args == null || args.isEmpty || args[0] == null) return;
    try {
      final onShift = args[0] as bool;
      log('[CourierLocationHub] ShiftStatus from server: $onShift');
      _currentShiftState = onShift;
    } catch (e) {
      log('[CourierLocationHub] ShiftStatus parse error: $e');
    }
  }

  void _onConnectionClosed() {
    _locationTimer?.cancel();
    _locationTimer = null;
    _hub = null;

    if (!_isActive) return;
    log('[CourierLocationHub] Permanent disconnect — will restart in ${_restartDelay.inSeconds}s');
    _scheduleRestart();
  }

  void _scheduleRestart() {
    _restartTimer?.cancel();
    _restartTimer = Timer(_restartDelay, () {
      if (_isActive) start();
    });
  }

  Future<void> _sendLocation() async {
    if (_hub == null || !_hub!.isConnected) return;
    try {
      // Only CHECK — never request. Requesting must be done once from the UI layer.
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log('[CourierLocationHub] Location permission not granted ($permission) — skipping');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      await _hub!.invoke('UpdateMyLocation', args: [position.latitude, position.longitude]);
    } catch (e) {
      log('[CourierLocationHub] Send location error: $e');
    }
  }

  Future<void> stop() async {
    _isActive = false;
    _locationTimer?.cancel();
    _locationTimer = null;
    _restartTimer?.cancel();
    _restartTimer = null;
    await _hub?.dispose();
    _hub = null;
  }
}
