import 'package:diyar/features/menu/domain/domain.dart';

class CategoryFoodEntity {
  final List<FoodEntity> foodModels;

  CategoryFoodEntity({
    required this.foodModels,
  });
  CategoryFoodEntity copyWith({
    List<FoodEntity>? foodModels,
  }) =>
      CategoryFoodEntity(
        foodModels: foodModels ?? this.foodModels,
      );
}
