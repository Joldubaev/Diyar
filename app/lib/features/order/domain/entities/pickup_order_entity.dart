import 'package:equatable/equatable.dart';
import 'food_item_order_entity.dart'; // Убедитесь, что этот файл существует и FoodItemOrderEntity определена

class PickupOrderEntity extends Equatable {
  final int dishesCount;
  final List<FoodItemOrderEntity> foods;
  final String prepareFor; // Время подготовки, например, "14:30"
  final int price;
  final String userName;
  final String userPhone;
  final String? comment;

  const PickupOrderEntity({
    required this.dishesCount,
    required this.foods,
    required this.prepareFor,
    required this.price,
    required this.userName,
    required this.userPhone,
    this.comment,
  });

  @override
  List<Object?> get props => [
        dishesCount,
        foods,
        prepareFor,
        price,
        userName,
        userPhone,
        comment,
      ];
}
