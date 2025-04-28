import 'package:flutter/widgets.dart';

import 'package:diyar/features/menu/domain/domain.dart';

class CartItemEntity {
  final FoodEntity? food;
  final int? quantity;
  final double? totalPrice;

  CartItemEntity({
    this.food,
    this.quantity,
    this.totalPrice,
  });

  CartItemEntity copyWith({
    ValueGetter<FoodEntity?>? food,
    ValueGetter<int?>? quantity,
    ValueGetter<double?>? totalPrice,
  }) {
    return CartItemEntity(
      food: food != null ? food() : this.food,
      quantity: quantity != null ? quantity() : this.quantity,
      totalPrice: totalPrice != null ? totalPrice() : this.totalPrice,
    );
  }
}
