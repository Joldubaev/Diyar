// To parse this JSON data, do
//
//     final userPickupHistoryModel = userPickupHistoryModelFromJson(jsonString);

import 'dart:convert';

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
        );

    factory UserPickupHistoryModel.fromJson(Map<String, dynamic> json) => UserPickupHistoryModel(
        comment: json["comment"],
        dishesCount: json["dishesCount"],
        foods: json["foods"] == null ? [] : List<FoodPickupModel>.from(json["foods"]!.map((x) => FoodPickupModel.fromJson(x))),
        id: json["id"],
        orderNumber: json["orderNumber"],
        prepareFor: json["prepareFor"],
        price: json["price"],
        status: json["status"],
        timeRequest: json["timeRequest"],
        userId: json["userId"],
        userName: json["userName"],
        userPhone: json["userPhone"],
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
    };
}

class FoodPickupModel {
    int? quantity;
    String? name;
    int? price;

    FoodPickupModel({
        this.quantity,
        this.name,
        this.price,
    });

    FoodPickupModel copyWith({
        int? quantity,
        String? name,
        int? price,
    }) => 
        FoodPickupModel(
            quantity: quantity ?? this.quantity,
            name: name ?? this.name,
            price: price ?? this.price,
        );

    factory FoodPickupModel.fromJson(Map<String, dynamic> json) => FoodPickupModel(
        quantity: json["quantity"],
        name: json["name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "name": name,
        "price": price,
    };
}
