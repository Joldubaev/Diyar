import 'package:diyar/features/curier/data/data.dart';
import 'package:diyar/features/curier/domain/domain.dart';

class CurierOrderModel {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final int? orderNumber;
  final int? dishesCount;
  final List<CurierFoodModel>? foods;
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

  CurierOrderModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'orderNumber': orderNumber,
      'dishesCount': dishesCount,
      'foods': foods?.map((x) => x.toJson()).toList(),
      'address': address,
      'houseNumber': houseNumber,
      'kvOffice': kvOffice,
      'intercom': intercom,
      'floor': floor,
      'entrance': entrance,
      'comment': comment,
      'paymentMethod': paymentMethod,
      'price': price,
      'timeRequest': timeRequest,
      'courierId': courierId,
      'status': status,
      'deliveryPrice': deliveryPrice,
      'sdacha': sdacha,
    };
  }

  factory CurierOrderModel.fromJson(Map<String, dynamic> map) {
    return CurierOrderModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      orderNumber: map['orderNumber'],
      dishesCount: map['dishesCount'],
      foods: map['foods'] != null
          ? List<CurierFoodModel>.from(map['foods']?.map((x) => CurierFoodModel.fromJson(x)))
          : null,
      address: map['address'],
      houseNumber: map['houseNumber'],
      kvOffice: map['kvOffice'],
      intercom: map['intercom'],
      floor: map['floor'],
      entrance: map['entrance'],
      comment: map['comment'],
      paymentMethod: map['paymentMethod'],
      price: map['price'],
      timeRequest: map['timeRequest'],
      courierId: map['courierId'],
      status: map['status'],
      deliveryPrice: map['deliveryPrice'],
      sdacha: map['sdacha'],
    );
  }

  factory CurierOrderModel.fromEntity(CurierEntity entity) {
    return CurierOrderModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userPhone: entity.userPhone,
      orderNumber: entity.orderNumber,
      dishesCount: entity.dishesCount,
      foods: entity.foods?.map((x) => CurierFoodModel.fromEntity(x)).toList(),
      address: entity.address,
      houseNumber: entity.houseNumber,
      kvOffice: entity.kvOffice,
      intercom: entity.intercom,
      floor: entity.floor,
      entrance: entity.entrance,
      comment: entity.comment,
      paymentMethod: entity.paymentMethod,
      price: entity.price,
      timeRequest: entity.timeRequest,
      courierId: entity.courierId,
      status: entity.status,
      deliveryPrice: entity.deliveryPrice,
      sdacha: entity.sdacha,
    );
  } 
  CurierEntity toEntity() {
    return CurierEntity(
      id: id,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      orderNumber: orderNumber,
      dishesCount: dishesCount,
      foods: foods?.map((x) => x.toEntity()).toList(),
      address: address,
      houseNumber: houseNumber,
      kvOffice: kvOffice,
      intercom: intercom,
      floor: floor,
      entrance: entrance,
      comment: comment,
      paymentMethod: paymentMethod,
      price: price,
      timeRequest: timeRequest,
      courierId: courierId,
      status: status,
      deliveryPrice: deliveryPrice,
      sdacha: sdacha,
    );
  }
}
