import 'package:diyar/features/payments/payments.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_payment_status_model.freezed.dart';

@freezed
class QrPaymentStatusModel with _$QrPaymentStatusModel {
  const factory QrPaymentStatusModel({
    required String code,
    required String message,
    required PaymentStatusEnum status,
  }) = _QrPaymentStatusModel;

  factory QrPaymentStatusModel.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? '';
    final message = json['message']?.toString() ?? '';
    // Статус извлекается из поля 'data' или 'code'
    final dataValue = json['data'] ?? json['code'];
    final status = _statusFromJson(dataValue);
    return QrPaymentStatusModel(
      code: code,
      message: message,
      status: status,
    );
  }

  factory QrPaymentStatusModel.fromEntity(QrPaymentStatusEntity entity) => QrPaymentStatusModel(
        code: entity.code,
        message: entity.message,
        status: entity.status,
      );
}

PaymentStatusEnum _statusFromJson(dynamic json) {
  if (json == null) return PaymentStatusEnum.unknown;
  // Если приходит строка 'SUCCESSFUL', обрабатываем отдельно
  if (json is String && json.toUpperCase() == 'SUCCESSFUL') {
    return PaymentStatusEnum.success;
  }
  return PaymentStatusMapper.fromCode(json);
}

extension QrPaymentStatusModelX on QrPaymentStatusModel {
  QrPaymentStatusEntity toEntity() => QrPaymentStatusEntity(
        code: code,
        message: message,
        status: status,
      );
}
