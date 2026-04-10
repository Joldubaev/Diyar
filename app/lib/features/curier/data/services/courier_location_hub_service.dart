import 'dart:async';
import 'dart:developer';

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';

/// Sends courier location to the hub every 2 seconds via SignalR.
/// Call [start] when opening the courier screen, [stop] when leaving.
@lazySingleton
class CourierLocationHubService {
  CourierLocationHubService(this._prefs);

  final SharedPreferences _prefs;
  HubManager? _hub;
  Timer? _locationTimer;
  static const _interval = Duration(seconds: 2);

  Future<void> start() async {
    if (_hub != null) return;

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
          loggerName: 'CourierLocationHub',
        ),
      );

      await _hub!.start();

      _locationTimer = Timer.periodic(_interval, (_) => _sendLocation());
      _sendLocation();
    } catch (e) {
      log('[CourierLocationHub] Start error: $e');
      _hub = null;
    }
  }

  Future<void> _sendLocation() async {
    if (_hub == null || !_hub!.isConnected) return;

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested != LocationPermission.whileInUse &&
            requested != LocationPermission.always) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      await _hub!.invoke('UpdateMyLocation', args: [
        position.latitude,
        position.longitude,
      ]);
    } catch (e) {
      log('[CourierLocationHub] Send location error: $e');
    }
  }

  Future<void> stop() async {
    _locationTimer?.cancel();
    _locationTimer = null;
    await _hub?.dispose();
    _hub = null;
  }
}
