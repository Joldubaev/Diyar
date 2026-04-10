import 'package:equatable/equatable.dart';

import 'package:diyar/features/menu/domain/domain.dart';

class CartItemEntity extends Equatable {
  final FoodEntity? food;
  final int? quantity;
  final double? totalPrice;

  const CartItemEntity({
    this.food,
    this.quantity,
    this.totalPrice,
  });

  @override
  List<Object?> get props => [food, quantity, totalPrice];

  CartItemEntity copyWith({
    FoodEntity? food,
    int? quantity,
    double? totalPrice,
  }) {
    return CartItemEntity(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
