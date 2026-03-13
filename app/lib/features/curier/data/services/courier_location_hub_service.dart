import 'dart:async';
import 'dart:developer';

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

/// Отправка геопозиции курьера в хаб courier-location-hub по WebSocket (SignalR).
/// Вызывать [start] при открытии экрана курьера, [stop] при уходе.
@lazySingleton
class CourierLocationHubService {
  CourierLocationHubService(this._prefs);

  final SharedPreferences _prefs;
  HubConnection? _hubConnection;
  Timer? _locationTimer;
  static const _interval = Duration(seconds: 2);

  /// Подключается к хабу с JWT в query и запускает периодическую отправку координат.
  Future<void> start() async {
    if (_hubConnection != null) return;

    final token = _prefs.getString(AppConst.accessToken);
    if (token == null || token.isEmpty) {
      log('[CourierLocationHub] No access token, skip start');
      return;
    }

    final url = '${ApiConst.courierLocationHubUrl}?access_token=${Uri.encodeComponent(token)}';

    try {
      _hubConnection = HubConnectionBuilder()
          .withUrl(url)
          .withAutomaticReconnect()
          .configureLogging(Logger('CourierLocationHub'))
          .build();

      _hubConnection!.onclose(({error}) {
        log('[CourierLocationHub] Connection closed: $error');
      });

      await _hubConnection!.start();
      log('[CourierLocationHub] Connected');

      _locationTimer = Timer.periodic(_interval, (_) => _sendLocation());
      // Первая отправка сразу после подключения
      _sendLocation();
    } catch (e) {
      log('[CourierLocationHub] Start error: $e');
      _hubConnection = null;
    }
  }

  Future<void> _sendLocation() async {
    final connection = _hubConnection;
    if (connection == null) return;

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
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      await connection.invoke('UpdateMyLocation', args: [
        position.latitude,
        position.longitude,
      ]);
    } catch (e) {
      log('[CourierLocationHub] Send location error: $e');
    }
  }

  /// Останавливает таймер и отключается от хаба.
  Future<void> stop() async {
    _locationTimer?.cancel();
    _locationTimer = null;
    if (_hubConnection != null) {
      try {
        await _hubConnection!.stop();
      } catch (e) {
        log('[CourierLocationHub] Stop error: $e');
      }
      _hubConnection = null;
    }
  }
}
