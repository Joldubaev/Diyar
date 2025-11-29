// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DistrictDataModelImpl _$$DistrictDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DistrictDataModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'],
    );

Map<String, dynamic> _$$DistrictDataModelImplToJson(
        _$DistrictDataModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
    };
