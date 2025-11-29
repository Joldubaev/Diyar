// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curier_food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurierFoodModelImpl _$$CurierFoodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CurierFoodModelImpl(
      quantity: (json['quantity'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CurierFoodModelImplToJson(
        _$CurierFoodModelImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'name': instance.name,
      'price': instance.price,
    };
