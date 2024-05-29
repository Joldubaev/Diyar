import 'dart:convert';
import 'create_order_model.dart';

PickupOrderModel pickupOrderModelFromJson(String str) => PickupOrderModel.fromJson(json.decode(str));

String pickupOrderModelToJson(PickupOrderModel data) => json.encode(data.toJson());

class PickupOrderModel {
  final int? dishesCount;
  final List<OrderFoodItem>? foods;
  final String? prepareFor;
  final int? price;
  final String? userName;
  final String? userPhone;
  final String? comment;

  PickupOrderModel({
    this.dishesCount,
    this.foods,
    this.prepareFor,
    this.price,
    this.userName,
    this.userPhone,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        "dishesCount": dishesCount,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "prepareFor": prepareFor,
        "price": price,
        "userName": userName,
        "userPhone": userPhone,
        "comment": comment,
      };

  factory PickupOrderModel.fromJson(Map<String, dynamic> json) => PickupOrderModel(
        dishesCount: json["dishesCount"],
        foods:
            json["foods"] == null ? [] : List<OrderFoodItem>.from(json["foods"]!.map((x) => OrderFoodItem.fromJson(x))),
        prepareFor: json["prepareFor"],
        price: json["price"],
        userName: json["userName"],
        userPhone: json["userPhone"],
        comment: json["comment"],
      );
}
