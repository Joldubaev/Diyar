// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      address: json['address'] as String,
      houseNumber: json['houseNumber'] as String,
      entrance: json['entrance'] as String?,
      floor: json['floor'] as String?,
      intercom: json['intercom'] as String?,
      kvOffice: json['kvOffice'] as String?,
      comment: json['comment'] as String?,
      region: json['region'] as String?,
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'houseNumber': instance.houseNumber,
      'entrance': instance.entrance,
      'floor': instance.floor,
      'intercom': instance.intercom,
      'kvOffice': instance.kvOffice,
      'comment': instance.comment,
      'region': instance.region,
    };
