import 'dart:async';
import 'dart:developer' as dev;

import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';
import 'package:diyar/features/web_payment/domain/services/i_payment_status_signalr_service.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_client/signalr_client.dart';

@Injectable(as: IPaymentStatusSignalRService)
class PaymentStatusSignalRServiceImpl implements IPaymentStatusSignalRService {
  HubManager? _hub;
  final _statusController = StreamController<PaymentStatusType>.broadcast();
  int? _currentOrderNum;

  @override
  Stream<PaymentStatusType> get statusStream => _statusController.stream;

  @override
  Future<void> connect(String orderNumber) async {
    if (_hub != null) return;

    final parsed = int.tryParse(orderNumber);
    if (parsed == null) {
      throw ArgumentError(
        'orderNumber must be a valid integer, got: "$orderNumber"',
      );
    }
    _currentOrderNum = parsed;

    _hub = HubManager(
      config: HubConnectionConfig(
        hubUrl: ApiConst.paymentStatusHubUrl,
        loggerName: 'PaymentStatusHub',
      ),
    );

    _hub!.on('ReceiveStatus', _onReceiveStatus);

    await _hub!.start();
    await _hub!.invoke('Subscribe', args: [_currentOrderNum!]);
    await _hub!.invoke('RequestStatus', args: [_currentOrderNum!]);
  }

  void _onReceiveStatus(List<Object?>? data) {
    dev.log('[PaymentStatusHub] ReceiveStatus raw: $data');
    if (data == null || data.isEmpty) return;
    try {
      final raw = data.first;
      final map = raw is Map ? Map<String, dynamic>.from(raw) : null;
      if (map == null) return;
      final status = map['status']?.toString() ?? '';
      if (status.isNotEmpty) {
        _statusController.add(PaymentStatusTypeMapper.fromCode(status));
      }
    } catch (e) {
      dev.log('[PaymentStatusHub] Parse error: $e');
    }
  }

  @override
  Future<void> disconnect(String orderNumber) async {
    try {
      if (_hub != null) {
        final orderNum = int.tryParse(orderNumber) ?? 0;
        await _hub!.invoke('Unsubscribe', args: [orderNum]);
      }
    } catch (e) {
      dev.log('[PaymentStatusHub] Disconnect error: $e');
    } finally {
      await _hub?.dispose();
      _hub = null;
      _currentOrderNum = null;
    }
  }

  void dispose() {
    _statusController.close();
  }
}
