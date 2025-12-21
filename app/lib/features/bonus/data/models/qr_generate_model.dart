import 'package:diyar/features/bonus/domain/entities/qr_generate_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_generate_model.freezed.dart';
part 'qr_generate_model.g.dart';

/// Model для данных генерации QR кода
@freezed
class QrGenerateModel with _$QrGenerateModel {
  const factory QrGenerateModel({
    String? qrData,
    String? expiresAtString,
  }) = _QrGenerateModel;

  factory QrGenerateModel.fromJson(Map<String, dynamic> json) => _$QrGenerateModelFromJson(json);
}

extension QrGenerateModelX on QrGenerateModel {
  QrGenerateEntity toEntity() {
    return QrGenerateEntity(qrData: qrData, expiresAt: expiresAtString);
  }
}
