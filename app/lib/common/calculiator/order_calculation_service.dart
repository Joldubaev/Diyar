// lib/features/order/domain/services/order_calculation_service.dart

import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OrderCalculationService {
  // --- Константы (примеры, должны быть получены из настроек/API) ---

  // Цена доставки

  /// 1. 🍽️ Рассчитывает общую стоимость только блюд (до скидок и контейнеров).
  double calculateItemsPrice(List<CartItemEntity> cartItems) {
    if (cartItems.isEmpty) return 0.0;
    return cartItems.fold<double>(
      0.0,
      (sum, item) => sum + ((item.food?.price?.toDouble() ?? 0.0) * (item.quantity ?? 0)),
    );
  }

  /// 2. 🍱 Рассчитывает общую стоимость контейнеров.
  double calculateContainerPrice(List<CartItemEntity> cartItems) {
    if (cartItems.isEmpty) return 0.0;
    return cartItems.fold<double>(
      0.0,
      (sum, item) => sum + ((item.food?.containerPrice?.toDouble() ?? 0.0) * (item.quantity ?? 0)),
    );
  }

  /// 3. 📉 Рассчитывает сумму скидки в денежном выражении.
  ///
  /// [itemsPrice] - общая цена блюд без учета контейнеров.
  /// [discountRatePercentage] - процент скидки (например, 10.0 для 10%).
  double calculateMonetaryDiscount(double itemsPrice, double discountRatePercentage) {
    if (discountRatePercentage <= 0) return 0.0;

    final double discountRate = discountRatePercentage / 100.0;
    return itemsPrice * discountRate;
  }

  /// 4. 💸 Рассчитывает общую стоимость заказа без учета доставки.
  /// (Блюда - Скидка + Контейнеры).
  double calculateSubtotalPrice({
    required double itemsPrice,
    required double containerPrice,
    required double monetaryDiscount,
  }) {
    final double discountedItemsPrice = itemsPrice - monetaryDiscount;
    return discountedItemsPrice + containerPrice;
  }

  /// 6. 💵 Рассчитывает полную общую стоимость заказа (Subtotal + Доставка).
  /// Бонусы не вычитаются на фронтенде, они передаются отдельно в amountToReduce.
  double calculateFinalTotalPrice({
    required double subtotalPrice,
    required double deliveryPrice,
    double amountToReduce = 0,
  }) {
    // Всегда возвращаем полную сумму без вычитания бонусов
    return subtotalPrice + deliveryPrice;
  }

  /// 7. 📏 Рассчитывает количество столовых приборов/блюд (включая опцию пользователя).
  ///
  /// [cartItems] - элементы корзины.
  /// [cutleryCount] - количество приборов, введенное пользователем.
  int calculateDishesCount({
    required List<CartItemEntity> cartItems,
    required int cutleryCount,
  }) {
    // Если вам нужно общее количество *порций*, а не только приборов:
    // int totalPortions = cartItems.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));
    // return totalPortions + cutleryCount;

    // Если вам нужно только количество приборов:
    return cutleryCount;
  }

  /// 8. 💱 Рассчитывает сдачу.
  ///
  /// [totalOrderCost] - Полная стоимость заказа.
  /// [sdachaAmount] - Сумма, которую дал клиент.
  int calculateChange(int totalOrderCost, int? sdachaAmount) {
    if (sdachaAmount == null || sdachaAmount <= totalOrderCost) {
      return 0;
    }
    return sdachaAmount - totalOrderCost;
  }
}
