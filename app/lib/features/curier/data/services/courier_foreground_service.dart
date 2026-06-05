import 'dart:developer';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Entry point for the background isolate created by the foreground service.
/// The handler is intentionally minimal — all real work (SignalR hub +
/// location updates) continues in the main isolate because the foreground
/// service keeps the OS process alive.
@pragma('vm:entry-point')
void courierForegroundTaskEntryPoint() {
  FlutterForegroundTask.setTaskHandler(_CourierTaskHandler());
}

class _CourierTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    log('[CourierForeground] Service started');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    log('[CourierForeground] Service stopped');
  }
}

/// Manages the Android foreground service / iOS background-location session.
///
/// Call [start] when the courier goes on shift and [stop] when they go off.
/// The foreground service keeps the OS process alive so [CourierLocationHubService]
/// (main isolate) can maintain the SignalR socket and keep sending
/// UpdateMyLocation uninterrupted while the app is in the background.
class CourierForegroundService {
  CourierForegroundService._();

  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'courier_on_shift',
        channelName: 'Курьер на смене',
        channelDescription: 'Геолокация активна пока вы на смене',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> start() async {
    try {
      if (await FlutterForegroundTask.isRunningService) return;
      final result = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Дияр Экспресс',
        notificationText: 'Вы на смене — геолокация активна',
        callback: courierForegroundTaskEntryPoint,
      );
      log('[CourierForeground] startService → $result');
    } catch (e) {
      log('[CourierForeground] startService error (ignored): $e');
    }
  }

  static Future<void> stop() async {
    try {
      if (!await FlutterForegroundTask.isRunningService) return;
      final result = await FlutterForegroundTask.stopService();
      log('[CourierForeground] stopService → $result');
    } catch (e) {
      log('[CourierForeground] stopService error (ignored): $e');
    }
  }
}
