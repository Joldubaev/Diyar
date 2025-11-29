// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      food: json['food'] == null
          ? null
          : FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'food': instance.food,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
    };
