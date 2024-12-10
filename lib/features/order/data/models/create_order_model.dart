// To parse this JSON data, do
//
//     final createOrderModel = createOrderModelFromJson(jsonString);

import 'dart:convert';

CreateOrderModel createOrderModelFromJson(String str) =>
    CreateOrderModel.fromJson(json.decode(str));

String createOrderModelToJson(CreateOrderModel data) =>
    json.encode(data.toJson());

class CreateOrderModel {
  String? address;
  String? comment;
  int? dishesCount;
  String? entrance;
  String? floor;
  List<OrderFoodItem>? foods;
  String? houseNumber;
  String? intercom;
  String? kvOffice;
  String? paymentMethod;
  int? price;
  String? userName;
  String? userPhone;
  int? deliveryPrice;
  int? sdacha;
  String ? region;

  CreateOrderModel({
    this.address,
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
    this.region
  });

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderModel(
        address: json["address"],
        comment: json["comment"],
        dishesCount: json["dishesCount"],
        entrance: json["entrance"],
        floor: json["floor"],
        foods: json["foods"] == null
            ? []
            : List<OrderFoodItem>.from(
                json["foods"]!.map((x) => OrderFoodItem.fromJson(x))),
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
        "foods": foods == null
            ? []
            : List<dynamic>.from(foods!.map((x) => x.toJson())),
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
}

class OrderFoodItem {
  String? name;
  int? price;
  int? quantity;

  OrderFoodItem({
    this.name,
    this.price,
    this.quantity,
  });

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) => OrderFoodItem(
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "quantity": quantity,
      };
}
