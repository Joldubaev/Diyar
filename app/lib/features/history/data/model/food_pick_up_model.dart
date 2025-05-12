import 'package:diyar/features/history/domain/domain.dart';

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

  factory FoodPickupModel.fromEntity(FoodPickUpEntity entity) {
    return FoodPickupModel(
      quantity: entity.quantity,
      name: entity.name,
      price: entity.price,
    );
  }
  FoodPickUpEntity toEntity() {
    return FoodPickUpEntity(
      quantity: quantity,
      name: name,
      price: price,
    );
  }
}
