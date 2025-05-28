import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:diyar/features/menu/domain/domain.dart';
part 'food_model.g.dart';

FoodModel foodModelFromJson(String str) => FoodModel.fromJson(json.decode(str));
String foodModelToJson(FoodModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class FoodModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? categoryId;
  @HiveField(4)
  int? price;
  @HiveField(5)
  String? weight;
  @HiveField(6)
  String? urlPhoto;
  @HiveField(7)
  bool? stopList;
  @HiveField(8)
  int? iDctMax;
  @HiveField(9)
  String? containerName;
  @HiveField(10)
  int? containerCount;
  @HiveField(11)
  int? quantity;
  @HiveField(12)
  num? containerPrice;

  FoodModel({
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.price,
    this.weight,
    this.urlPhoto,
    this.stopList,
    this.iDctMax,
    this.containerName,
    this.containerCount,
    this.quantity,
    this.containerPrice,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        categoryId: json["categoryId"],
        price: json["price"],
        weight: json["weight"],
        urlPhoto: json["urlPhoto"],
        stopList: json["stopList"],
        iDctMax: json["idctMax"],
        containerName: json["containerName"],
        containerCount: json["containerCount"],
        quantity: json["quantity"],
        containerPrice: json["containerPrice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "categoryId": categoryId,
        "price": price,
        "weight": weight,
        "urlPhoto": urlPhoto,
        "stopList": stopList,
        "idctMax": iDctMax,
        "containerName": containerName,
        "containerCount": containerCount,
        "containerPrice": containerPrice,
        if (quantity != null) "quantity": quantity,
      };

  factory FoodModel.fromEntity(FoodEntity entity) {
    return FoodModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      categoryId: entity.categoryId,
      price: entity.price,
      weight: entity.weight,
      urlPhoto: entity.urlPhoto,
      stopList: entity.stopList,
      iDctMax: entity.iDctMax,
      containerName: entity.containerName,
      containerCount: entity.containerCount,
      quantity: entity.quantity,
      containerPrice: entity.containerPrice,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      price: price,
      weight: weight,
      urlPhoto: urlPhoto,
      stopList: stopList,
      iDctMax: iDctMax,
      containerName: containerName,
      containerCount: containerCount,
      quantity: quantity,
      containerPrice: containerPrice?.toInt(),
    );
  }
}
