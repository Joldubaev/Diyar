import 'package:equatable/equatable.dart';

/// Общая сущность для отображения деталей заказа
/// Используется независимо от источника данных (active_order, curier, history)
class OrderDetailEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<OrderDetailFoodItem>? foods;
  final String? address;
  final String? houseNumber;
  final String? kvOffice;
  final String? intercom;
  final String? floor;
  final String? entrance;
  final String? comment;
  final String? paymentMethod;
  final int? price;
  final String? timeRequest;
  final String? courierId;
  final String? status;
  final int? deliveryPrice;
  final int? sdacha;
  final double? amountToReduce;

  const OrderDetailEntity({
    this.id,
    this.userId,
    this.userName,
    this.userPhone,
    this.orderNumber,
    this.dishesCount,
    this.foods,
    this.address,
    this.houseNumber,
    this.kvOffice,
    this.intercom,
    this.floor,
    this.entrance,
    this.comment,
    this.paymentMethod,
    this.price,
    this.timeRequest,
    this.courierId,
    this.status,
    this.deliveryPrice,
    this.sdacha,
    this.amountToReduce,
  });

  String get fullAddress => '${address ?? ''}, д. ${houseNumber ?? ''}'.trim();
  
  double get totalPrice => (price ?? 0) + (deliveryPrice ?? 0) - (amountToReduce ?? 0);

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userPhone,
        orderNumber,
        dishesCount,
        foods,
        address,
        houseNumber,
        kvOffice,
        intercom,
        floor,
        entrance,
        comment,
        paymentMethod,
        price,
        timeRequest,
        courierId,
        status,
        deliveryPrice,
        sdacha,
        amountToReduce,
      ];
}

/// Упрощенная модель блюда для отображения в деталях заказа
class OrderDetailFoodItem extends Equatable {
  final String name;
  final int quantity;
  final int? price;

  const OrderDetailFoodItem({
    required this.name,
    required this.quantity,
    this.price,
  });

  @override
  List<Object?> get props => [name, quantity, price];
}
