import 'package:diyar/features/menu/menu.dart';

class CatergoryFoodModel {
  final List<FoodModel>? foodModels;

  CatergoryFoodModel({
    this.foodModels,
  });

  factory CatergoryFoodModel.fromJson(Map<String, dynamic> json) => CatergoryFoodModel(
        foodModels: List<FoodModel>.from(json["message"].map((x) => FoodModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(foodModels!.map((x) => x.toJson())),
      };

  factory CatergoryFoodModel.fromEntity(CategoryFoodEntity entity) {
    return CatergoryFoodModel(
      foodModels: entity.foodModels.map((e) => FoodModel.fromEntity(e)).toList(),
    );
  }
  CategoryFoodEntity toEntity() {
    return CategoryFoodEntity(
      foodModels: foodModels!.map((e) => e.toEntity()).toList(),
    );
  }
}
