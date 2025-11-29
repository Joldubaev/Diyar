// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodModelImpl _$$FoodModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      price: (json['price'] as num?)?.toInt(),
      weight: json['weight'] as String?,
      urlPhoto: json['urlPhoto'] as String?,
      stopList: json['stopList'] as bool?,
      iDctMax: (json['iDctMax'] as num?)?.toInt(),
      containerName: json['containerName'] as String?,
      containerCount: (json['containerCount'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      containerPrice: json['containerPrice'] as num?,
    );

Map<String, dynamic> _$$FoodModelImplToJson(_$FoodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'price': instance.price,
      'weight': instance.weight,
      'urlPhoto': instance.urlPhoto,
      'stopList': instance.stopList,
      'iDctMax': instance.iDctMax,
      'containerName': instance.containerName,
      'containerCount': instance.containerCount,
      'quantity': instance.quantity,
      'containerPrice': instance.containerPrice,
    };
