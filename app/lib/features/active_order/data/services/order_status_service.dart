import 'dart:async';
import 'dart:developer';

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

@lazySingleton
class OrderStatusService {
  OrderStatusService(this._prefs);

  final SharedPreferences _prefs;
  HubManager? _deliveryHub;
  HubManager? _pickupHub;
  Object? _userId;
  final _statusController = StreamController<List<OrderStatusEntity>>.broadcast();

  Stream<List<OrderStatusEntity>> get statusStream => _statusController.stream;

  /// [connectPickupHub]: если `false`, хаб самовывоза не трогаем (меньше шума в логах,
  /// пока на API нет `MapHub` для pickup).
  Future<void> initAndConnect({bool connectPickupHub = true}) async {
    try {
      final token = _prefs.getString(AppConst.accessToken);
      if (token == null) return;

      final nameId = JwtDecoder.decode(token)['nameid'];
      if (nameId == null) return;

      await _disconnectHubs();
      _userId = nameId;

      _deliveryHub = HubManager(
        config: HubConnectionConfig(
          hubUrl: ApiConst.orderStatusHubUrl,
          accessToken: token,
          loggerName: 'OrderStatusHub',
        ),
        onReconnected: _resubscribeDelivery,
      );

      _deliveryHub!.on('ReceiveStatus', (data) {
        if (_statusController.isClosed) return;
        if (data == null || data.isEmpty) return;
        try {
          final statuses = data
              .whereType<Map>()
              .map(
                (j) => OrderStatusModel.fromJson(
                  Map<String, dynamic>.from(j),
                ).toEntity(),
              )
              .toList();
          if (statuses.isNotEmpty) {
            _statusController.add(statuses);
          }
        } catch (e) {
          log('[OrderStatusService] ReceiveStatus parse error: $e');
        }
      });

      await _deliveryHub!.start();
      try {
        await _resubscribeDelivery();
      } catch (e) {
        log('[OrderStatusService] Delivery resubscribe error: $e');
      }

      if (!connectPickupHub) return;

      _pickupHub = HubManager(
        config: HubConnectionConfig(
          hubUrl: ApiConst.pickupOrderStatusHubUrl,
          accessToken: token,
          loggerName: 'PickupOrderStatusHub',
        ),
        onReconnected: _resubscribePickup,
      );

      _pickupHub!.on('ReceivePickupStatus', _onReceivePickupStatus);

      try {
        await _pickupHub!.start();
        await _resubscribePickup();
      } catch (e, st) {
        final hint = e.toString().contains('404')
            ? ' На сервере нет маршрута negotiate для pickup (проверьте MapHub /pickup-order-status-hub).'
            : '';
        log(
          '[OrderStatusService] Pickup hub недоступен, доставка остаётся в реал-тайме: $e$hint\n$st',
        );
        await _safeUnsubscribeDispose(_pickupHub);
        _pickupHub = null;
      }
    } catch (e) {
      log('[OrderStatusService] Error: $e');
      await _disconnectHubs();
    }
  }

  void _onReceivePickupStatus(List<Object?>? data) {
    if (_statusController.isClosed) return;
    if (data == null || data.isEmpty) return;
    try {
      final raw = data.first;
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      final entity = OrderStatusModel.fromJson(map).toEntity();
      _statusController.add([entity]);
    } catch (e) {
      log('[OrderStatusService] ReceivePickupStatus parse error: $e');
    }
  }

  Future<void> _resubscribeDelivery() async {
    final h = _deliveryHub;
    final id = _userId;
    if (h == null || id == null) return;
    await h.invoke('Subscribe', args: [id]);
    await h.invoke('RequestStatus', args: [id]);
  }

  Future<void> _resubscribePickup() async {
    final h = _pickupHub;
    final id = _userId;
    if (h == null || id == null) return;
    await h.invoke('Subscribe', args: [id]);
    await h.invoke('RequestStatus', args: [id]);
  }

  Future<void> _disconnectHubs() async {
    await _safeUnsubscribeDispose(_deliveryHub);
    _deliveryHub = null;
    await _safeUnsubscribeDispose(_pickupHub);
    _pickupHub = null;
  }

  Future<void> _safeUnsubscribeDispose(HubManager? hub) async {
    if (hub == null) return;
    final id = _userId;
    try {
      if (id != null) await hub.invoke('Unsubscribe', args: [id]);
    } catch (e) {
      log('[OrderStatusService] Unsubscribe: $e');
    }
    await hub.dispose();
  }

  Future<void> dispose() async {
    await _disconnectHubs();
    _userId = null;
    await _statusController.close();
  }
}
