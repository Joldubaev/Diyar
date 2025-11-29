import 'package:diyar/features/payments/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_code_model.freezed.dart';
part 'qr_code_model.g.dart';

@freezed
class QrCodeModel with _$QrCodeModel {
  const factory QrCodeModel({
    String? qrData,
    String? transactionId,
  }) = _QrCodeModel;

  factory QrCodeModel.fromJson(Map<String, dynamic> json) =>
      _$QrCodeModelFromJson(json);

  factory QrCodeModel.fromEntity(QrCodeEntity entity) => QrCodeModel(
        qrData: entity.qrData,
        transactionId: entity.transactionId,
      );
}

extension QrCodeModelX on QrCodeModel {
  QrCodeEntity toEntity() => QrCodeEntity(
        qrData: qrData,
        transactionId: transactionId,
      );
}
