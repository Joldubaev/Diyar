import 'package:diyar/common/calculator/order_calculation_service.dart';
import 'package:diyar/features/cart/domain/domain.dart';
import 'package:diyar/features/home_content/domain/domain.dart';

/// Результаты расчета цен корзины
class CartCalculationResult {
  final double itemsPrice;
  final double containerPrice;
  final double monetaryDiscount;
  final double subtotalPrice;

  const CartCalculationResult({
    required this.itemsPrice,
    required this.containerPrice,
    required this.monetaryDiscount,
    required this.subtotalPrice,
  });
}

/// Класс для расчета цен корзины с учетом скидок
class CartPriceCalculator {
  final OrderCalculationService _calculationService;

  CartPriceCalculator(this._calculationService);

  /// Рассчитывает все цены корзины с учетом скидки
  ///
  /// [cartItems] - список товаров в корзине
  /// [discountPercentage] - процент скидки от 0 до 100
  ///
  /// Возвращает результат расчета с ценами, скидками и итоговой суммой.
  /// Если корзина пуста, возвращает нулевые значения.
  CartCalculationResult calculatePrices({
    required List<CartItemEntity> cartItems,
    required double discountPercentage,
  }) {
    // Проверка на пустую корзину для оптимизации
    if (cartItems.isEmpty) {
      return const CartCalculationResult(
        itemsPrice: 0.0,
        containerPrice: 0.0,
        monetaryDiscount: 0.0,
        subtotalPrice: 0.0,
      );
    }

    final itemsPrice = _calculationService.calculateItemsPrice(cartItems);
    final containerPrice = _calculationService.calculateContainerPrice(cartItems);
    final monetaryDiscount = _calculationService.calculateMonetaryDiscount(
      itemsPrice,
      discountPercentage,
    );
    final subtotalPrice = _calculationService.calculateSubtotalPrice(
      itemsPrice: itemsPrice,
      containerPrice: containerPrice,
      monetaryDiscount: monetaryDiscount,
    );

    return CartCalculationResult(
      itemsPrice: itemsPrice,
      containerPrice: containerPrice,
      monetaryDiscount: monetaryDiscount,
      subtotalPrice: subtotalPrice,
    );
  }

  /// Получает процент скидки из списка акций
  ///
  /// [sales] - список акций (может быть пустым)
  ///
  /// Возвращает процент скидки из первой акции или 0.0, если акций нет
  double getDiscountPercentage(List<SaleEntity> sales) {
    if (sales.isEmpty) return 0.0;
    final firstSale = sales.first;
    return firstSale.discount?.toDouble() ?? 0.0;
  }
}
