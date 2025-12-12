import 'package:flutter/material.dart';

/// Утилиты для работы с темой в карточках товаров
class FoodThemeUtils {
  /// Получает BorderRadius из темы карточки или возвращает значение по умолчанию
  ///
  /// [theme] - текущая тема приложения
  /// [defaultRadius] - радиус по умолчанию (по умолчанию 12)
  /// Возвращает BorderRadius из cardTheme.shape или BorderRadius.circular(defaultRadius) по умолчанию
  static BorderRadius getCardBorderRadius(
    ThemeData theme, [
    double defaultRadius = 12,
  ]) {
    final cardShape = theme.cardTheme.shape;
    if (cardShape is RoundedRectangleBorder) {
      final borderRadius = cardShape.borderRadius;
      if (borderRadius is BorderRadius) {
        return borderRadius;
      }
    }
    return BorderRadius.circular(defaultRadius);
  }

  /// Получает текст стиль для веса товара
  static TextStyle? getWeightTextStyle(ThemeData theme) {
    return theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }

  /// Получает текст стиль для цены товара
  static TextStyle? getPriceTextStyle(ThemeData theme) {
    return theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w500,
    );
  }

  /// Получает текст стиль для названия товара
  static TextStyle? getNameTextStyle(ThemeData theme) {
    return theme.textTheme.bodyMedium;
  }
}
