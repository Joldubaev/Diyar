// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActiveOrderModelImpl _$$ActiveOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ActiveOrderModelImpl(
      order: json['order'] == null
          ? null
          : OrderActiveItemModel.fromJson(
              json['order'] as Map<String, dynamic>),
      courierName: json['courierName'] as String?,
      courierNumber: json['courierNumber'] as String?,
    );

Map<String, dynamic> _$$ActiveOrderModelImplToJson(
        _$ActiveOrderModelImpl instance) =>
    <String, dynamic>{
      'order': instance.order,
      'courierName': instance.courierName,
      'courierNumber': instance.courierNumber,
    };
