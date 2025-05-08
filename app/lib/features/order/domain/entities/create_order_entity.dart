import 'package:diyar/core/components/components.dart';
import 'package:equatable/equatable.dart';

class CreateOrderEntity extends Equatable {
  final String address; // Полный адрес
  final String? comment;
  final int dishesCount;
  final String? entrance; // Подъезд
  final String? floor; // Этаж
  final List<FoodItemOrderEntity> foods;
  final String houseNumber; // Номер дома (если `address` не включает его)
  final String? intercom; // Домофон
  final String? kvOffice; // Квартира/Офис
  final String paymentMethod; // Например, 'cash', 'card_online', 'card_courier'
  final int price; // Общая стоимость заказа
  final String userName;
  final String userPhone;
  final int deliveryPrice;
  final int? sdacha; // Сумма, с которой нужна сдача
  final String? region; // Район/Регион (если нужно отдельно)

  const CreateOrderEntity({
    required this.address,
    this.comment,
    required this.dishesCount,
    this.entrance,
    this.floor,
    required this.foods,
    required this.houseNumber,
    this.intercom,
    this.kvOffice,
    required this.paymentMethod,
    required this.price,
    required this.userName,
    required this.userPhone,
    required this.deliveryPrice,
    this.sdacha,
    this.region,
  });

  @override
  List<Object?> get props => [
        address,
        comment,
        dishesCount,
        entrance,
        floor,
        foods,
        houseNumber,
        intercom,
        kvOffice,
        paymentMethod,
        price,
        userName,
        userPhone,
        deliveryPrice,
        sdacha,
        region,
      ];
}
