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

  @override
  List<Object?> get props => [dishId, name, price, quantity];
}
