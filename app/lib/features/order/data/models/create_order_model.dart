import 'dart:convert';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:diyar/features/order/domain/domain.dart';

CreateOrderModel createOrderModelFromJson(String str) => CreateOrderModel.fromJson(json.decode(str));

String createOrderModelToJson(CreateOrderModel data) => json.encode(data.toJson());

class CreateOrderModel {
  String? address;
  String? comment;
  int? dishesCount;
  String? entrance;
  String? floor;
  List<FoodItemOrderModel>? foods;
  String? houseNumber;
  String? intercom;
  String? kvOffice;
  String? paymentMethod;
  int? price;
  String? userName;
  String? userPhone;
  int? deliveryPrice;
  int? sdacha;
  String? region;

  CreateOrderModel(
      {this.address,
      this.comment,
      this.dishesCount,
      this.entrance,
      this.floor,
      this.foods,
      this.houseNumber,
      this.intercom,
      this.kvOffice,
      this.paymentMethod,
      this.price,
      this.userName,
      this.userPhone,
      this.deliveryPrice,
      this.sdacha,
      this.region});

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) => CreateOrderModel(
        address: json["address"],
        comment: json["comment"],
        dishesCount: json["dishesCount"],
        entrance: json["entrance"],
        floor: json["floor"],
        foods: json["foods"] == null
            ? []
            : List<FoodItemOrderModel>.from(json["foods"]!.map((x) => FoodItemOrderModel.fromJson(x))),
        houseNumber: json["houseNumber"],
        intercom: json["intercom"],
        kvOffice: json["kvOffice"],
        paymentMethod: json["paymentMethod"],
        price: json["price"],
        userName: json["userName"],
        userPhone: json["userPhone"],
        deliveryPrice: json["deliveryPrice"],
        sdacha: json["sdacha"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "comment": comment,
        "dishesCount": dishesCount,
        "entrance": entrance,
        "floor": floor,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "houseNumber": houseNumber,
        "intercom": intercom,
        "kvOffice": kvOffice,
        "paymentMethod": paymentMethod,
        "price": price,
        "userName": userName,
        "userPhone": userPhone,
        "deliveryPrice": deliveryPrice,
        "sdacha": sdacha,
        "region": region
      };

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) {
    return CreateOrderModel(
      address: entity.address,
      comment: entity.comment,
      dishesCount: entity.dishesCount,
      entrance: entity.entrance,
      floor: entity.floor,
      foods: entity.foods.map((food) => FoodItemOrderModel.fromEntity(food)).toList(),
      houseNumber: entity.houseNumber,
      intercom: entity.intercom,
      kvOffice: entity.kvOffice,
      paymentMethod: entity.paymentMethod,
      price: entity.price,
      userName: entity.userName,
      userPhone: entity.userPhone,
      deliveryPrice: entity.deliveryPrice,
      sdacha: entity.sdacha,
      region: entity.region,
    );
  }
  CreateOrderEntity toEntity() {
    return CreateOrderEntity(
      address: address ?? '',
      comment: comment,
      dishesCount: dishesCount ?? 0,
      entrance: entrance,
      floor: floor,
      foods: foods?.map((food) => food.toEntity()).toList() ?? [],
      houseNumber: houseNumber ?? '',
      intercom: intercom,
      kvOffice: kvOffice,
      paymentMethod: paymentMethod ?? '',
      price: price ?? 0,
      userName: userName ?? '',
      userPhone: userPhone ?? '',
      deliveryPrice: deliveryPrice ?? 0,
      sdacha: sdacha,
      region: region,
    );
  }
}
