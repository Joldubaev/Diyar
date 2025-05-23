import 'dart:convert';
// import 'package:diyar/features/order/data/models/food_item_order_model.dart'; // Заменено на model.dart, если он экспортирует FoodItemOrderModel
import 'package:diyar/core/core.dart';
import 'package:diyar/features/pick_up/domain/domain.dart';

PickupOrderModel pickupOrderModelFromJson(String str) => PickupOrderModel.fromJson(json.decode(str));

String pickupOrderModelToJson(PickupOrderModel data) => json.encode(data.toJson());

class PickupOrderModel {
  final int? dishesCount;
  final List<FoodItemOrderModel>? foods;
  final String? prepareFor;
  final int? price;
  final String? userName;
  final String? userPhone;
  final String? comment;
  final String? paymentMethod;

  PickupOrderModel({
    this.dishesCount,
    this.foods,
    this.prepareFor,
    this.price,
    this.userName,
    this.userPhone,
    this.comment,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        "dishesCount": dishesCount,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x.toJson())),
        "prepareFor": prepareFor,
        "price": price,
        "userName": userName,
        "userPhone": userPhone,
        "comment": comment,
        "paymentMethod": paymentMethod,
      };

  factory PickupOrderModel.fromJson(Map<String, dynamic> json) => PickupOrderModel(
        dishesCount: json["dishesCount"],
        foods: json["foods"] == null
            ? []
            : List<FoodItemOrderModel>.from(json["foods"]!.map((x) => FoodItemOrderModel.fromJson(x))),
        prepareFor: json["prepareFor"],
        price: json["price"],
        userName: json["userName"],
        userPhone: json["userPhone"],
        comment: json["comment"],
        paymentMethod: json["paymentMethod"],
      );

  factory PickupOrderModel.fromEntity(PickupOrderEntity entity) {
    return PickupOrderModel(
      dishesCount: entity.dishesCount,
      foods: entity.foods.map((foodEntity) => FoodItemOrderModel.fromEntity(foodEntity)).toList(),
      prepareFor: entity.prepareFor,
      price: entity.price,
      userName: entity.userName,
      userPhone: entity.userPhone,
      comment: entity.comment,
      paymentMethod: entity.paymentMethod,
    );
  }

  PickupOrderEntity toEntity() {
    if (dishesCount == null || prepareFor == null || price == null || userName == null || userPhone == null) {
      // Consider logging this error as well
      throw Exception(
          'PickupOrderModel toEntity Error: A required field for PickupOrderEntity is null. dishesCount: $dishesCount, prepareFor: $prepareFor, price: $price, userName: $userName, userPhone: $userPhone');
    }
    return PickupOrderEntity(
      dishesCount: dishesCount!,
      // Если foods в модели nullable, а в сущности нет (или наоборот), нужна соответствующая обработка.
      // Предполагаем, что foods в PickupOrderEntity не nullable, поэтому `?? []`.
      foods: foods?.map((foodModel) => foodModel.toEntity()).toList() ?? [],
      prepareFor: prepareFor!,
      price: price!,
      userName: userName!,
      userPhone: userPhone!,
      comment: comment, // comment может быть nullable и в модели, и в сущности
      paymentMethod: paymentMethod, // paymentMethod может быть nullable и в модели, и в сущности
    );
  }
}
