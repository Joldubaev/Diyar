import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_generate_entity.freezed.dart';

/// Entity для данных генерации QR кода
@freezed
class QrGenerateEntity with _$QrGenerateEntity {
  const factory QrGenerateEntity({
    String? qrData, // URL для QR кода
    String? expiresAt,
  }) = _QrGenerateEntity;
}
