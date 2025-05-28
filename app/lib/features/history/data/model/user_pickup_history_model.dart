import 'dart:convert';

import 'package:diyar/features/history/data/data.dart';
import 'package:diyar/features/history/domain/domain.dart';

UserPickupHistoryModel userPickupHistoryModelFromJson(String str) => UserPickupHistoryModel.fromJson(json.decode(str));

String userPickupHistoryModelToJson(UserPickupHistoryModel data) => json.encode(data.toJson());

class UserPickupHistoryModel {
  String? comment;
  int? dishesCount;
  List<FoodPickupModel>? foods;
  String? id;
  int? orderNumber;
  String? prepareFor;
  int? price;
  String? status;
  String? timeRequest;
  String? userId;
  String? userName;
  String? userPhone;
  String? paymentMethod;

  UserPickupHistoryModel({
    this.comment,
    this.dishesCount,
    this.foods,
    this.id,
    this.orderNumber,
    this.prepareFor,
    this.price,
    this.status,
    this.timeRequest,
    this.userId,
    this.userName,
    this.userPhone,
    this.paymentMethod,
  });

  UserPickupHistoryModel copyWith({
    String? comment,
    int? dishesCount,
    List<FoodPickupModel>? foods,
    String? id,
    int? orderNumber,
    String? prepareFor,
    int? price,
    String? status,
    String? timeRequest,
    String? userId,
    String? userName,
    String? userPhone,
    String? paymentMethod,
  }) =>
      UserPickupHistoryModel(
        comment: comment ?? this.comment,
        dishesCount: dishesCount ?? this.dishesCount,
        foods: foods ?? this.foods,
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        prepareFor: prepareFor ?? this.prepareFor,
        price: price ?? this.price,
        status: status ?? this.status,
        timeRequest: timeRequest ?? this.timeRequest,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userPhone: userPhone ?? this.userPhone,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory UserPickupHistoryModel.fromJson(Map<String, dynamic> json) => UserPickupHistoryModel(
        comment: json["comment"],
        dishesCount: json["dishesCount"],
        foods: json["foods"] == null
            ? []
            : List<FoodPickupModel>.from(json["foods"]!.map((x) => FoodPickupModel.fromJson(x))),
        id: json["id"],
        orderNumber: json["orderNumber"],
        prepareFor: json["prepareFor"],
        price: json["price"],
        status: json["status"],
        timeRequest: json["timeRequest"],
        userId: json["userId"],
        userName: json["userName"],
        userPhone: json["userPhone"],
        paymentMethod: json["paymentMethod"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "dishesCount": dishesCount,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "id": id,
        "orderNumber": orderNumber,
        "prepareFor": prepareFor,
        "price": price,
        "status": status,
        "timeRequest": timeRequest,
        "userId": userId,
        "userName": userName,
        "userPhone": userPhone,
        "paymentMethod": paymentMethod,
      };

  factory UserPickupHistoryModel.fromEntity(UserPickupHistoryEntity entity) {
    return UserPickupHistoryModel(
      comment: entity.comment,
      dishesCount: entity.dishesCount,
      foods: entity.foods?.map((food) => FoodPickupModel.fromEntity(food)).toList(),
      id: entity.id,
      orderNumber: entity.orderNumber,
      prepareFor: entity.prepareFor,
      price: entity.price,
      status: entity.status,
      timeRequest: entity.timeRequest,
      userId: entity.userId,
      userName: entity.userName,
      userPhone: entity.userPhone,
      paymentMethod: entity.paymentMethod,
    );
  }
  UserPickupHistoryEntity toEntity() {
    return UserPickupHistoryEntity(
      comment: comment,
      dishesCount: dishesCount,
      foods: foods?.map((food) => food.toEntity()).toList(),
      id: id,
      orderNumber: orderNumber,
      prepareFor: prepareFor,
      price: price,
      status: status,
      timeRequest: timeRequest,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      paymentMethod: paymentMethod,
    );
  }
}
