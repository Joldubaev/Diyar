import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color grey = Color(0xFF999999);
  static const Color grey1 = Color(0xFFE8E8E8);
  static const Color grey2 = Color(0xFFF5F5F5);
  static const Color grey3 = Color(0xFFD9D9D9);
  /// Фон экранов #F5F5F5. Доступ: context.scaffoldBg, context.bgColor.
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  /// Основной цвет бренда — оранжевый из гайда (HEX #d67c1c, RGB 214 124 28).
  static const MaterialColor primary = MaterialColor(_primaryValue, <int, Color>{
    50: Color(0xFFFFF3E7),
    100: Color(0xFFFEE0C2),
    200: Color(0xFFFCCB99),
    300: Color(0xFFFAB570),
    400: Color(0xFFF9A352),
    500: Color(_primaryValue),
    600: Color(0xFFE57119),
    700: Color(0xFFCF6516),
    800: Color(0xFFB95912),
    900: Color(0xFF93460C),
  });
  static const int _primaryValue = 0xFFD67C1C;

  // Бонусная карточка: градиент и акцент
  static const Color bonusGradientStart = Color(0xFFFAB43C);
  static const Color bonusGradientEnd = Color(0xFFEC663B);
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

  static BoxDecoration shadowDecoration(BuildContext context) => BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
