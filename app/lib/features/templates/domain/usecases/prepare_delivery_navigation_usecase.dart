import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/templates/domain/entities/template_entity.dart';
import 'package:injectable/injectable.dart';

/// Данные для навигации на DeliveryFormRoute
class DeliveryNavigationData {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final double deliveryPrice;
  final String? address;

  const DeliveryNavigationData({
    required this.cart,
    required this.totalPrice,
    required this.dishCount,
    required this.deliveryPrice,
    this.address,
  });
}

/// Данные для навигации на OrderMapRoute
class OrderMapNavigationData {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;

  const OrderMapNavigationData({
    required this.cart,
    required this.totalPrice,
    required this.dishCount,
  });
}

/// Use case для подготовки данных навигации на основе шаблона и корзины
@injectable
class PrepareDeliveryNavigationUseCase {
  final OrderCalculationService _calculationService;

  PrepareDeliveryNavigationUseCase(this._calculationService);

  /// Подготавливает данные для навигации на DeliveryFormRoute с адресом из шаблона
  DeliveryNavigationData prepareDeliveryWithTemplate({
    required TemplateEntity template,
    required CartLoaded cartState,
  }) {
    final address = _buildAddressFromTemplate(template);

    // Используем сохраненную цену доставки из шаблона, если она есть, иначе 0.0
    final deliveryPrice = template.price?.toDouble() ?? 0.0;

    // Пересчитываем totalPrice с учетом containerPrice
    final priceCalculator = CartPriceCalculator(_calculationService);
    final priceResult = priceCalculator.calculatePrices(
      cartItems: cartState.items,
      discountPercentage: 0.0, // Скидка будет применена позже, если нужно
    );
    final calculatedTotalPrice = priceResult.subtotalPrice.toInt();

    return DeliveryNavigationData(
      cart: cartState.items,
      totalPrice: calculatedTotalPrice,
      dishCount: cartState.totalItems,
      deliveryPrice: deliveryPrice,
      address: address,
    );
  }

  /// Подготавливает данные для навигации на OrderMapRoute
  OrderMapNavigationData prepareOrderMap({
    required CartLoaded cartState,
  }) {
    // Пересчитываем totalPrice с учетом containerPrice
    final priceCalculator = CartPriceCalculator(_calculationService);
    final priceResult = priceCalculator.calculatePrices(
      cartItems: cartState.items,
      discountPercentage: 0.0, // Скидка будет применена позже, если нужно
    );
    final calculatedTotalPrice = priceResult.subtotalPrice.toInt();

    return OrderMapNavigationData(
      cart: cartState.items,
      totalPrice: calculatedTotalPrice,
      dishCount: cartState.totalItems,
    );
  }

  String _buildAddressFromTemplate(TemplateEntity template) {
    final address = template.addressData.address;
    final houseNumber = template.addressData.houseNumber;
    return houseNumber.isNotEmpty ? '$address, д. $houseNumber' : address;
  }
}
