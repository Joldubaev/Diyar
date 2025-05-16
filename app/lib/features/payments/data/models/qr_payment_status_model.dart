import 'package:diyar/features/payments/payments.dart';

class QrPaymentStatusModel {
  final String code;
  final String message;
  final PaymentStatusEnum status;

  QrPaymentStatusModel({
    required this.code,
    required this.message,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  factory QrPaymentStatusModel.fromJson(Map<String, dynamic> map) {
    return QrPaymentStatusModel(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
      status: PaymentStatusMapper.fromCode(map['code'] ?? ''),
    );
  }

  factory QrPaymentStatusModel.fromEntity(QrPaymentStatusEntity entity) {
    return QrPaymentStatusModel(
      code: entity.code,
      message: entity.message,
      status: entity.status,
    );
  }
  QrPaymentStatusEntity toEntity() {
    return QrPaymentStatusEntity(
      code: code,
      message: message,
      status: status,
    );
  }
}
