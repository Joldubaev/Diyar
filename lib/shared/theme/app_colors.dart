import 'package:flutter/material.dart';

class AppColors {
  static const Color grey = Color(0xFF999999);
  static const Color grey1 = Color(0xFFE8E8E8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black1 = Color.fromARGB(180, 0, 0, 0);
  static const Color blue = Color(0xFF1672EC);
  static const Color green = Color(0xFF219653);
  static const Color red = Color(0xFFEB5757);

  /// The color swatch for the application's primary color.
  static const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFFFF2E9),
    100: Color(0xFFFFDFC8),
    200: Color(0xFFFFCAA3),
    300: Color(0xFFFFB47E),
    400: Color(0xFFFFA462),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFFFF8C3F),
    700: Color(0xFFFF8137),
    800: Color(0xFFFF772F),
    900: Color(0xFFFF6520),
  });
  static const int _primaryPrimaryValue = 0xFFFF9446;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_primaryAccentValue),
    400: Color(0xFFFFDDCF),
    700: Color(0xFFFFCAB6),
  });
  static const int _primaryAccentValue = 0xFFFFFFFF;
}
