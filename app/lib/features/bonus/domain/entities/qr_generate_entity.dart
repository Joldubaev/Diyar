import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_generate_entity.freezed.dart';

@freezed
class QrGenerateEntity with _$QrGenerateEntity {
  // Добавление приватного конструктора позволяет писать методы внутри класса
  const QrGenerateEntity._();

  const factory QrGenerateEntity({
    String? qrData,
    String? expiresAt,
  }) = _QrGenerateEntity;

  /// Бизнес-логика теперь внутри Entity (Senior подход)
  /// Это делает Entity самодостаточным объектом.
  String? get token {
    final data = qrData?.trim();
    if (data == null || data.isEmpty) return null;

    try {
      final uri = Uri.parse(data);
      // Если это URL с параметром token — берем его, иначе возвращаем саму строку
      return uri.queryParameters['token'] ?? data;
    } catch (_) {
      return data;
    }
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    final expiry = DateTime.tryParse(expiresAt!);
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }
}
