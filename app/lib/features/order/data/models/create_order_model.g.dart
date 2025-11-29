// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderModelImpl _$$CreateOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderModelImpl(
      address: json['address'] as String?,
      comment: json['comment'] as String?,
      dishesCount: (json['dishesCount'] as num?)?.toInt(),
      entrance: json['entrance'] as String?,
      floor: json['floor'] as String?,
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodItemOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      houseNumber: json['houseNumber'] as String?,
      intercom: json['intercom'] as String?,
      kvOffice: json['kvOffice'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      price: (json['price'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
      deliveryPrice: (json['deliveryPrice'] as num?)?.toInt(),
      sdacha: (json['sdacha'] as num?)?.toInt(),
      region: json['region'] as String?,
    );

Map<String, dynamic> _$$CreateOrderModelImplToJson(
        _$CreateOrderModelImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'comment': instance.comment,
      'dishesCount': instance.dishesCount,
      'entrance': instance.entrance,
      'floor': instance.floor,
      'foods': instance.foods,
      'houseNumber': instance.houseNumber,
      'intercom': instance.intercom,
      'kvOffice': instance.kvOffice,
      'paymentMethod': instance.paymentMethod,
      'price': instance.price,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'deliveryPrice': instance.deliveryPrice,
      'sdacha': instance.sdacha,
      'region': instance.region,
    };
