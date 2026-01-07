import 'dart:async';
import 'dart:developer';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
// features/active_order/data/services/order_status_service.dart

@lazySingleton
class OrderStatusService {
  final SharedPreferences _prefs;
  HubConnection? _hubConnection;

  // Используем BehaviorSubject из rxdart, если хотим, чтобы новые
  // слушатели сразу получали последнее состояние (опционально)
  final _statusController = StreamController<List<OrderStatusEntity>>.broadcast();

  OrderStatusService(this._prefs);

  Stream<List<OrderStatusEntity>> get statusStream => _statusController.stream;

  Future<void> initAndConnect() async {
    try {
      final token = _prefs.getString(AppConst.accessToken);
      if (token == null) return;

      final nameId = JwtDecoder.decode(token)['nameid'];

      _hubConnection = HubConnectionBuilder()
          .withUrl("https://api.diyar.kg/order-status-hub")
          .withAutomaticReconnect()
          .configureLogging(Logger("SignalR")) // Добавляем логи
          .build();

      _hubConnection?.on("ReceiveStatus", (data) {
        if (data != null && data.isNotEmpty) {
          final list = data as List;
          final statuses = list.map((j) => OrderStatusModel.fromJson(Map<String, dynamic>.from(j)).toEntity()).toList();
          _statusController.add(statuses);
        }
      });

      // Слушаем закрытие соединения
      _hubConnection?.onclose(({error}) {
        log('SignalR Connection Closed: $error');
      });

      await _hubConnection?.start();
      await _hubConnection?.invoke("Subscribe", args: [nameId]);
      await _hubConnection?.invoke("RequestStatus", args: [nameId]);
    } catch (e) {
      log('SignalR Error: $e');
    }
  }

  void dispose() {
    _hubConnection?.stop();
    _statusController.close();
  }
}
