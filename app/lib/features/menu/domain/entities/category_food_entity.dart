import 'package:equatable/equatable.dart';

import 'package:diyar/features/menu/domain/domain.dart';

class CategoryFoodEntity extends Equatable {
  final List<FoodEntity> foodModels;

  const CategoryFoodEntity({
    required this.foodModels,
  });

  @override
  List<Object?> get props => [foodModels];

  CategoryFoodEntity copyWith({
    List<FoodEntity>? foodModels,
  }) =>
      CategoryFoodEntity(
        foodModels: foodModels ?? this.foodModels,
      );
}
