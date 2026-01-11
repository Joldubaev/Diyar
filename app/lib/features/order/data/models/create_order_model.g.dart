// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateOrderModelImpl _$$CreateOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateOrderModelImpl(
      addressData:
          AddressModel.fromJson(json['addressData'] as Map<String, dynamic>),
      contactInfo: ContactInfoModel.fromJson(
          json['contactInfo'] as Map<String, dynamic>),
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodItemOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dishesCount: (json['dishesCount'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String,
      price: (json['price'] as num).toInt(),
      deliveryPrice: (json['deliveryPrice'] as num).toInt(),
      sdacha: (json['sdacha'] as num?)?.toInt(),
      amountToReduce: (json['amountToReduce'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CreateOrderModelImplToJson(
        _$CreateOrderModelImpl instance) =>
    <String, dynamic>{
      'addressData': instance.addressData,
      'contactInfo': instance.contactInfo,
      'foods': instance.foods,
      'dishesCount': instance.dishesCount,
      'paymentMethod': instance.paymentMethod,
      'price': instance.price,
      'deliveryPrice': instance.deliveryPrice,
      'sdacha': instance.sdacha,
      'amountToReduce': instance.amountToReduce,
    };
