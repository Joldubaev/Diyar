import 'package:diyar/common/calculator/order_calculation_service.dart';
import 'package:diyar/features/cart/domain/domain.dart';
import 'package:diyar/features/cart/presentation/pages/cart_price_calculator.dart';
import 'package:diyar/features/home_content/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'cart_price_state.dart';

/// Cubit для управления расчетом цен корзины с учетом скидок
@injectable
class CartPriceCubit extends Cubit<CartPriceState> {
  final CartPriceCalculator _priceCalculator;
  List<CartItemEntity> _currentCartItems;
  double _currentDiscountPercentage = 0.0;

  CartPriceCubit(
    OrderCalculationService calculationService, {
    List<CartItemEntity> initialItems = const [],
  })  : _priceCalculator = CartPriceCalculator(calculationService),
        _currentCartItems = initialItems,
        super(const CartPriceInitial()) {
    if (initialItems.isNotEmpty) {
      _recalculate();
    }
  }

  /// Обновляет элементы корзины и пересчитывает цены
  void updateCartItems(List<CartItemEntity> cartItems) {
    _currentCartItems = cartItems;
    _recalculate();
  }

  /// Обновляет процент скидки из акций и пересчитывает цены
  void updateDiscountFromSales(List<SaleEntity> sales) {
    _currentDiscountPercentage = _priceCalculator.getDiscountPercentage(sales);
    _recalculate();
  }

  /// Обновляет процент скидки и пересчитывает цены
  ///
  /// [discountPercentage] - процент скидки от 0 до 100
  void updateDiscount(double discountPercentage) {
    _currentDiscountPercentage = discountPercentage;
    _recalculate();
  }

  /// Получает процент скидки из списка акций
  double getDiscountPercentage(List<SaleEntity> sales) {
    return _priceCalculator.getDiscountPercentage(sales);
  }

  /// Получает текущий процент скидки
  double getCurrentDiscountPercentage() => _currentDiscountPercentage;

  /// Пересчитывает цены с текущими данными
  void _recalculate() {
    if (_currentCartItems.isEmpty) {
      emit(const CartPriceCalculated(
        itemsPrice: 0.0,
        containerPrice: 0.0,
        monetaryDiscount: 0.0,
        subtotalPrice: 0.0,
      ));
      return;
    }

    final result = _priceCalculator.calculatePrices(
      cartItems: _currentCartItems,
      discountPercentage: _currentDiscountPercentage,
    );

    emit(CartPriceCalculated(
      itemsPrice: result.itemsPrice,
      containerPrice: result.containerPrice,
      monetaryDiscount: result.monetaryDiscount,
      subtotalPrice: result.subtotalPrice,
    ));
  }
}
