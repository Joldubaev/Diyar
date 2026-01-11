// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupOrderModelImpl _$$PickupOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupOrderModelImpl(
      dishesCount: (json['dishesCount'] as num?)?.toInt(),
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodItemOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prepareFor: json['prepareFor'] as String?,
      price: (json['price'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
      comment: json['comment'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      amountToReduce: (json['amountToReduce'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PickupOrderModelImplToJson(
        _$PickupOrderModelImpl instance) =>
    <String, dynamic>{
      'dishesCount': instance.dishesCount,
      'foods': instance.foods,
      'prepareFor': instance.prepareFor,
      'price': instance.price,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'comment': instance.comment,
      'paymentMethod': instance.paymentMethod,
      'amountToReduce': instance.amountToReduce,
    };
