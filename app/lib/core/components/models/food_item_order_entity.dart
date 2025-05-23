import 'package:equatable/equatable.dart';

class FoodItemOrderEntity extends Equatable {
  final String dishId;
  final String name;
  final int price;
  final int quantity;

  const FoodItemOrderEntity({
    required this.dishId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory FoodItemOrderEntity.fromJson(Map<String, dynamic> json) {
    return FoodItemOrderEntity(
      dishId: json['dishId'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
    );
  }

  @override
  List<Object?> get props => [dishId, name, price, quantity];
}
