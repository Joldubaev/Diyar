import 'package:diyar/core/components/components.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:equatable/equatable.dart';

class CreateOrderEntity extends Equatable {
  final AddressEntity addressData;
  final ContactInfoEntity contactInfo;
  final int dishesCount;
  final List<FoodItemOrderEntity> foods;
  final String paymentMethod; // Например, 'cash', 'card_online', 'card_courier'
  final int price; // Общая стоимость заказа
  final int deliveryPrice;
  final int? sdacha; // Сумма, с которой нужна сдача
  final double? amountToReduce; // Сумма бонусов для списания

  const CreateOrderEntity({
    required this.addressData,
    required this.contactInfo,
    required this.dishesCount,
    required this.foods,
    required this.paymentMethod,
    required this.price,
    required this.deliveryPrice,
    this.sdacha,
    this.amountToReduce,
  });

  @override
  List<Object?> get props => [
        addressData,
        contactInfo,
        dishesCount,
        foods,
        paymentMethod,
        price,
        deliveryPrice,
        sdacha,
        amountToReduce,
      ];
}
