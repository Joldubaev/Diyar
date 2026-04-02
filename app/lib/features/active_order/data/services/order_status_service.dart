import 'dart:async';
import 'dart:developer';

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
  HubManager? _hub;
  final _statusController =
      StreamController<List<OrderStatusEntity>>.broadcast();

  Stream<List<OrderStatusEntity>> get statusStream => _statusController.stream;

  Future<void> initAndConnect() async {
    try {
      final token = _prefs.getString(AppConst.accessToken);
      if (token == null) return;

      final nameId = JwtDecoder.decode(token)['nameid'];

      _hub = HubManager(
        config: const HubConnectionConfig(
          hubUrl: 'https://api.diyar.kg/order-status-hub',
          loggerName: 'OrderStatusHub',
        ),
      );

      _hub!.on('ReceiveStatus', (data) {
        if (data != null && data.isNotEmpty) {
          final statuses = (data as List)
              .map((j) => OrderStatusModel.fromJson(
                    Map<String, dynamic>.from(j as Map),
                  ).toEntity())
              .toList();
          _statusController.add(statuses);
        }
      });

      await _hub!.start();
      await _hub!.invoke('Subscribe', args: [nameId]);
      await _hub!.invoke('RequestStatus', args: [nameId]);
    } catch (e) {
      log('[OrderStatusService] Error: $e');
    }
  }

  Future<void> dispose() async {
    await _hub?.dispose();
    _hub = null;
    await _statusController.close();
  }
}
