import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:diyar/features/menu/menu.dart';

class OrderActiveItemEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<FoodEntity>? foods;
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

  const OrderActiveItemEntity({
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
        price,
        timeRequest,
        courierId,
        status,
        deliveryPrice,
        sdacha,
      ];

  OrderActiveItemEntity copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? userId,
    ValueGetter<String?>? userName,
    ValueGetter<String?>? userPhone,
    ValueGetter<int?>? orderNumber,
    ValueGetter<int?>? dishesCount,
    ValueGetter<List<FoodEntity>?>? foods,
    ValueGetter<String?>? address,
    ValueGetter<String?>? houseNumber,
    ValueGetter<String?>? kvOffice,
    ValueGetter<String?>? intercom,
    ValueGetter<String?>? floor,
    ValueGetter<String?>? entrance,
    ValueGetter<String?>? comment,
    ValueGetter<String?>? paymentMethod,
    ValueGetter<int?>? price,
    ValueGetter<String?>? timeRequest,
    ValueGetter<String?>? courierId,
    ValueGetter<String?>? status,
    ValueGetter<int?>? deliveryPrice,
    ValueGetter<int?>? sdacha,
  }) {
    return OrderActiveItemEntity(
      id: id != null ? id() : this.id,
      userId: userId != null ? userId() : this.userId,
      userName: userName != null ? userName() : this.userName,
      userPhone: userPhone != null ? userPhone() : this.userPhone,
      orderNumber: orderNumber != null ? orderNumber() : this.orderNumber,
      dishesCount: dishesCount != null ? dishesCount() : this.dishesCount,
      foods: foods != null ? foods() : this.foods,
      address: address != null ? address() : this.address,
      houseNumber: houseNumber != null ? houseNumber() : this.houseNumber,
      kvOffice: kvOffice != null ? kvOffice() : this.kvOffice,
      intercom: intercom != null ? intercom() : this.intercom,
      floor: floor != null ? floor() : this.floor,
      entrance: entrance != null ? entrance() : this.entrance,
      comment: comment != null ? comment() : this.comment,
      paymentMethod: paymentMethod != null ? paymentMethod() : this.paymentMethod,
      price: price != null ? price() : this.price,
      timeRequest: timeRequest != null ? timeRequest() : this.timeRequest,
      courierId: courierId != null ? courierId() : this.courierId,
      status: status != null ? status() : this.status,
      deliveryPrice: deliveryPrice != null ? deliveryPrice() : this.deliveryPrice,
      sdacha: sdacha != null ? sdacha() : this.sdacha,
    );
  }

  String get fullAddress => '${address ?? ''}, д. ${houseNumber ?? ''}'.trim();
  bool get isCompleted => status == 'completed';

  /// Определяет, является ли заказ самовывозом (pickup)
  /// Обычно pickup заказы не имеют адреса доставки
  bool get isPickup => address == null || address!.isEmpty;
}
