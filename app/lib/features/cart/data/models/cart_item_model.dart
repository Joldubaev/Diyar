import '../../../features.dart';

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

  CartItemModel copyWith({
    FoodModel? food,
    int? quantity,
    double? totalPrice,
  }) {
    return CartItemModel(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
