import 'dart:async';
import 'dart:developer' as dev;

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:diyar/features/web_payment/domain/services/i_payment_status_signalr_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

@Injectable(as: IPaymentStatusSignalRService)
class PaymentStatusSignalRServiceImpl implements IPaymentStatusSignalRService {
  HubConnection? _hubConnection;
  final _statusController = StreamController<PaymentStatusType>.broadcast();
  int? _currentOrderNum;

  @override
  Stream<PaymentStatusType> get statusStream => _statusController.stream;

  Future<void> _resubscribe() async {
    if (_hubConnection == null || _currentOrderNum == null) return;
    try {
      await _hubConnection!.invoke('Subscribe', args: [_currentOrderNum!]);
      await _hubConnection!.invoke('RequestStatus', args: [_currentOrderNum!]);
      dev.log('[PaymentStatusSignalR] Re-subscribed after reconnect');
    } catch (e) {
      dev.log('[PaymentStatusSignalR] Resubscribe error: $e');
    }
  }

  @override
  Future<void> connect(String orderNumber) async {
    if (_hubConnection != null) return;

    final parsed = int.tryParse(orderNumber);
    if (parsed == null) {
      dev.log('[PaymentStatusSignalR] Invalid orderNumber: "$orderNumber" is not a valid integer');
      throw ArgumentError('orderNumber must be a valid integer, got: "$orderNumber"');
    }
    _currentOrderNum = parsed;

    try {
      final logger = Logger('PaymentStatusSignalR')..level = Level.ALL;
      _hubConnection = HubConnectionBuilder()
          .withUrl(ApiConst.paymentStatusHubUrl)
          .withAutomaticReconnect()
          .configureLogging(logger)
          .build();

      _hubConnection!.on('ReceiveStatus', _onReceiveStatus);
      _hubConnection!.onclose(({error}) {
        dev.log('[PaymentStatusSignalR] Connection closed: $error');
      });
      _hubConnection!.onreconnected(({connectionId}) {
        dev.log('[PaymentStatusSignalR] Reconnected, resubscribing...');
        unawaited(_resubscribe());
      });

      await _hubConnection!.start();

      await _resubscribe();
    } catch (e) {
      dev.log('[PaymentStatusSignalR] Connect error: $e');
      rethrow;
    }
  }

  void _onReceiveStatus(List<Object?>? data) {
    dev.log('[PaymentStatusSignalR] ReceiveStatus raw: $data');
    if (data == null || data.isEmpty) return;
    try {
      final raw = data.isNotEmpty ? data.first : data;
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      dev.log(
          '[PaymentStatusSignalR] ReceiveStatus parsed: orderNumber=${map['orderNumber']}, status=${map['status']}');
      final status = map['status']?.toString() ?? '';
      if (status.isNotEmpty) {
        _statusController.add(PaymentStatusTypeMapper.fromCode(status));
      }
    } catch (e) {
      dev.log('[PaymentStatusSignalR] Parse error: $e');
    }
  }

  @override
  Future<void> disconnect(String orderNumber) async {
    try {
      if (_hubConnection != null) {
        final orderNum = int.tryParse(orderNumber) ?? 0;
        await _hubConnection!.invoke('Unsubscribe', args: [orderNum]);
        await _hubConnection!.stop();
      }
    } catch (e) {
      dev.log('[PaymentStatusSignalR] Disconnect error: $e');
    } finally {
      _hubConnection = null;
      _currentOrderNum = null;
    }
  }

  void dispose() {
    _statusController.close();
  }
}
