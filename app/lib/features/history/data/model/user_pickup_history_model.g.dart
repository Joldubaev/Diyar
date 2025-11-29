// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pickup_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPickupHistoryModelImpl _$$UserPickupHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPickupHistoryModelImpl(
      comment: json['comment'] as String?,
      dishesCount: (json['dishesCount'] as num?)?.toInt(),
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodPickupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
      prepareFor: json['prepareFor'] as String?,
      price: (json['price'] as num?)?.toInt(),
      status: json['status'] as String?,
      timeRequest: json['timeRequest'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$$UserPickupHistoryModelImplToJson(
        _$UserPickupHistoryModelImpl instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'dishesCount': instance.dishesCount,
      'foods': instance.foods,
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'prepareFor': instance.prepareFor,
      'price': instance.price,
      'status': instance.status,
      'timeRequest': instance.timeRequest,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'paymentMethod': instance.paymentMethod,
    };
