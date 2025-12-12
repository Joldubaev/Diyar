import 'package:intl/intl.dart';

/// Утилита для форматирования цен товаров
class FoodPriceFormatter {
  static final NumberFormat _priceFormatter = NumberFormat('#,###', 'ru');

  /// Форматирует цену для отображения
  ///
  /// [price] - цена (может быть null)
  /// Возвращает отформатированную строку с разделителями тысяч или '-', если price == null
  static String formatPrice(int? price) {
    if (price == null) return '-';
    return _priceFormatter.format(price);
  }

  /// Форматирует цену с валютой
  ///
  /// [price] - цена (может быть null)
  /// [currency] - валюта (по умолчанию 'сом')
  /// Возвращает отформатированную строку с ценой и валютой или '- $currency', если price == null
  static String formatPriceWithCurrency(int? price, [String currency = 'сом']) {
    final formattedPrice = formatPrice(price);
    return formattedPrice == '-' ? '- $currency' : '$formattedPrice $currency';
  }
}
