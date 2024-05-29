import 'dart:convert';

FoodModel foodModelFromJson(String str) => FoodModel.fromJson(json.decode(str));

String foodModelToJson(FoodModel data) => json.encode(data.toJson());

class FoodModel {
  String? id;
  String? name;
  String? categoryId;
  int? price;
  String? weight;
  String? urlPhoto;
  bool? stopList;
  int? iDctMax;
  String? containerName;
  int? containerCount;

  FoodModel({
    this.id,
    this.name,
    this.categoryId,
    this.price,
    this.weight,
    this.urlPhoto,
    this.stopList,
    this.iDctMax,
    this.containerName,
    this.containerCount,
  });

  FoodModel copyWith({
    String? id,
    String? name,
    String? categoryId,
    int? price,
    String? weight,
    String? urlPhoto,
    bool? stopList,
    int? iDctMax,
    String? containerName,
    int? containerCount,
  }) =>
      FoodModel(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        price: price ?? this.price,
        weight: weight ?? this.weight,
        urlPhoto: urlPhoto ?? this.urlPhoto,
        stopList: stopList ?? this.stopList,
        iDctMax: iDctMax ?? this.iDctMax,
        containerName: containerName ?? this.containerName,
        containerCount: containerCount ?? this.containerCount,
      );

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["id"],
        name: json["name"],
        categoryId: json["categoryId"],
        price: json["price"],
        weight: json["weight"],
        urlPhoto: json["URLPhoto"],
        stopList: json["stopList"],
        iDctMax: json["iDCTMax"],
        containerName: json["containerName"],
        containerCount: json["containerCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "categoryId": categoryId,
        "price": price,
        "weight": weight,
        "URLPhoto": urlPhoto,
        "stopList": stopList,
        "iDCTMax": iDctMax,
        "containerName": containerName,
        "containerCount": containerCount,
      };
}
