// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatergoryFoodModelImpl _$$CatergoryFoodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CatergoryFoodModelImpl(
      foodModels: (json['foodModels'] as List<dynamic>?)
          ?.map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CatergoryFoodModelImplToJson(
        _$CatergoryFoodModelImpl instance) =>
    <String, dynamic>{
      'foodModels': instance.foodModels,
    };
