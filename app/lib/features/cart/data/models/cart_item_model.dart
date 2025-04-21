import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/menu/menu.dart';

class CartItemModel {
  final FoodModel? food;
  final int? quantity;
  final double? totalPrice;

  CartItemModel({
    this.food,
    this.quantity,
    this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        food: FoodModel.fromJson(json["food"]),
        quantity: json["quantity"],
        totalPrice: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "food": food?.toJson(),
        "quantity": quantity,
        "price": totalPrice,
      };
  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      food: entity.food != null ? FoodModel.fromEntity(entity.food!) : null,
      quantity: entity.quantity,
      totalPrice: entity.totalPrice,
    );
  }
  CartItemEntity toEntity() {
    return CartItemEntity(
      food: food?.toEntity(),
      quantity: quantity,
      totalPrice: totalPrice,
    );
  }
}
