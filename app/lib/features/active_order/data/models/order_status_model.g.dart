// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderStatusModelImpl _$$OrderStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusModelImpl(
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$OrderStatusModelImplToJson(
        _$OrderStatusModelImpl instance) =>
    <String, dynamic>{
      'orderNumber': instance.orderNumber,
      'status': instance.status,
    };
