import 'package:diyar/features/web_payment/domain/enum/payment_status_type.dart';

abstract interface class IPaymentStatusSignalRService {
  Stream<PaymentStatusType> get statusStream;
  Future<void> connect(String orderNumber);
  Future<void> disconnect(String orderNumber);
}
