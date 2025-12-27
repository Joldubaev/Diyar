import 'package:flutter/services.dart';

class AppHaptics {
  /// Легкий отклик при нажатии на кнопки или карточки
  static Future<void> lightClick() async {
    await HapticFeedback.lightImpact();
  }

  /// Отклик при возникновении ошибки
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }

  /// Отклик при успешном действии (например, оплата)
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }
}