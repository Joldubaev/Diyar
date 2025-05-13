import 'package:diyar/features/curier/domain/domain.dart';

class CurierFoodModel {
  final int? quantity;
  final String? name;
  final int? price;

  CurierFoodModel({
    this.quantity,
    this.name,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'name': name,
      'price': price,
    };
  }

  factory CurierFoodModel.fromJson(Map<String, dynamic> map) {
    return CurierFoodModel(
      quantity: map['quantity']?.toInt(),
      name: map['name'],
      price: map['price']?.toInt(),
    );
  }

  factory CurierFoodModel.fromEntity(CurierFoodEntity entity) {
    return CurierFoodModel(
      quantity: entity.quantity,
      name: entity.name,
      price: entity.price,
    );
  }
  CurierFoodEntity toEntity() {
    return CurierFoodEntity(
      quantity: quantity,
      name: name,
      price: price,
    );
  }
}
