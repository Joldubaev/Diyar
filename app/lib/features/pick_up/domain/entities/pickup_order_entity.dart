import 'package:diyar/common/components/components.dart';
import 'package:equatable/equatable.dart';

class PickupOrderEntity extends Equatable {
  final int dishesCount;
  final List<FoodItemOrderEntity> foods;
  final String prepareFor;
  final int price;
  final String userName;
  final String userPhone;
  final String? comment;
  final String? paymentMethod;
  final double? amountToReduce; // Сумма бонусов для списания

  const PickupOrderEntity({
    required this.dishesCount,
    required this.foods,
    required this.prepareFor,
    required this.price,
    required this.userName,
    required this.userPhone,
    this.comment,
    this.paymentMethod,
    this.amountToReduce,
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
        paymentMethod,
        amountToReduce,
      ];
}
