import 'package:diyar/features/payments/payments.dart';
import 'package:equatable/equatable.dart';

class QrPaymentStatusEntity extends Equatable {
  final String code;
  final String message;
   final PaymentStatusEnum status;

  const QrPaymentStatusEntity({
    required this.code,
    required this.message,
    required this.status,
  });

  @override
  List<Object?> get props => [
        code,
        message,
        status,
      ];
}
