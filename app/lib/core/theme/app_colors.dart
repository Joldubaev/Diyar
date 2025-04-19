import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color grey = Color(0xFF999999);
  static const Color grey1 = Color(0xFFE8E8E8);
  static const Color grey2 = Color(0xFFF5F5F5);
  static const Color grey3 = Color(0xFFD9D9D9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black1 = Color.fromARGB(180, 0, 0, 0);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Семантические цвета
  static const Color blue = Color(0xFF1672EC);
  static const Color green = Color(0xFF219653);
  static const Color red = Color(0xFFEB5757);
  static const Color yellow = Color(0xFFF2C94C);
  static const Color orange = Color(0xFFF2994A);

  // Состояния
  static const Color success = green;
  static const Color error = red;
  static const Color warning = yellow;
  static const Color info = blue;

  // Интерактивные состояния
  static const Color hover = Color(0xFFF5F5F5);
  static const Color pressed = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);

  /// The color swatch for the application's primary color.
  static const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFFFF0E7),
    100: Color(0xFFFFD9C3),
    200: Color(0xFFFFBF9C),
    300: Color(0xFFFFA574),
    400: Color(0xFFFF9256),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFFFF7732),
    700: Color(0xFFFF6C2B),
    800: Color(0xFFFF6224),
    900: Color(0xFFFF4F17),
  });
  static const int _primaryPrimaryValue = 0xFFFF7F38;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_primaryAccentValue),
    400: Color(0xFFFFD5C9),
    700: Color(0xFFFFC1B0),
  });
  static const int _primaryAccentValue = 0xFFFFFDFC;
}
