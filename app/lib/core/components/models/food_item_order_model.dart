import 'package:flutter/widgets.dart';
import 'food_item_order_entity.dart';

class FoodItemOrderModel {
  final String dishId;
  final String name;
  final int price;
  final int quantity;

  FoodItemOrderModel({
    required this.dishId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory FoodItemOrderModel.fromJson(Map<String, dynamic> json) => FoodItemOrderModel(
        dishId: json["dishId"].toString(),
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "dishId": dishId,
        "name": name,
        "price": price,
        "quantity": quantity,
      };

  factory FoodItemOrderModel.fromEntity(FoodItemOrderEntity entity) {
    return FoodItemOrderModel(
      dishId: entity.dishId,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
    );
  }
  FoodItemOrderEntity toEntity() {
    return FoodItemOrderEntity(
      dishId: dishId,
      name: name,
      price: price,
      quantity: quantity,
    );
  }

  FoodItemOrderModel copyWith({
    ValueGetter<String>? dishId,
    ValueGetter<String>? name,
    ValueGetter<int>? price,
    ValueGetter<int>? quantity,
  }) {
    return FoodItemOrderModel(
      dishId: dishId != null ? dishId() : this.dishId,
      name: name != null ? name() : this.name,
      price: price != null ? price() : this.price,
      quantity: quantity != null ? quantity() : this.quantity,
    );
  }
}
