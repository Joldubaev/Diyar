import 'package:equatable/equatable.dart';

import 'curier_food_entity.dart';

class CurierEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<CurierFoodEntity>? foods;
  final String? address;
  final String? houseNumber;
  final String? kvOffice;
  final String? intercom;
  final String? floor;
  final String? entrance;
  final String? comment;
  final String? paymentMethod;
  /// Статус оплаты с бэка: New, Await, Successful, Charge, Reject.
  final String? paymentStatus;
  final int? price;
  final String? timeRequest;
  final String? courierId;
  final String? status;
  final int? deliveryPrice;
  final int? sdacha;
  final int? amountToReduce;

  const CurierEntity({
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
    this.paymentStatus,
    this.price,
    this.timeRequest,
    this.courierId,
    this.status,
    this.deliveryPrice,
    this.sdacha,
    this.amountToReduce,
  });

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
        paymentStatus,
        price,
        timeRequest,
        courierId,
        status,
        deliveryPrice,
        sdacha,
        amountToReduce,
      ];
}
