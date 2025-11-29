// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerOrderModelImpl _$$CustomerOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerOrderModelImpl(
      id: json['id'] as String?,
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: json['address'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$CustomerOrderModelImplToJson(
        _$CustomerOrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foods': instance.foods,
      'address': instance.address,
      'status': instance.status,
    };
