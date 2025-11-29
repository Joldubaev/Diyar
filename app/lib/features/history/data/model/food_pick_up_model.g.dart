// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pick_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodPickupModelImpl _$$FoodPickupModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodPickupModelImpl(
      quantity: (json['quantity'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FoodPickupModelImplToJson(
        _$FoodPickupModelImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'name': instance.name,
      'price': instance.price,
    };
