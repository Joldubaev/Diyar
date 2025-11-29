import 'package:diyar/features/menu/menu.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_food_model.freezed.dart';
part 'category_food_model.g.dart';

@freezed
class CatergoryFoodModel with _$CatergoryFoodModel {
  const factory CatergoryFoodModel({
    List<FoodModel>? foodModels,
  }) = _CatergoryFoodModel;

  factory CatergoryFoodModel.fromJson(Map<String, dynamic> json) => _$CatergoryFoodModelFromJson(json);

  factory CatergoryFoodModel.fromEntity(CategoryFoodEntity entity) => CatergoryFoodModel(
        foodModels: entity.foodModels.map((e) => FoodModel.fromEntity(e)).toList(),
      );
}

extension CatergoryFoodModelX on CatergoryFoodModel {
  CategoryFoodEntity toEntity() => CategoryFoodEntity(
        foodModels: foodModels?.map((e) => e.toEntity()).toList() ?? [],
      );
}
