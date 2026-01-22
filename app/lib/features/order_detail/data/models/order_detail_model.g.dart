// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDetailModelImpl _$$OrderDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderDetailModelImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userPhone: json['userPhone'] as String?,
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
      dishesCount: (json['dishesCount'] as num?)?.toInt(),
      foods: (json['foods'] as List<dynamic>?)
          ?.map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: json['address'] as String?,
      houseNumber: json['houseNumber'] as String?,
      kvOffice: json['kvOffice'] as String?,
      intercom: json['intercom'] as String?,
      floor: json['floor'] as String?,
      entrance: json['entrance'] as String?,
      comment: json['comment'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      price: (json['price'] as num?)?.toInt(),
      timeRequest: json['timeRequest'] as String?,
      courierId: json['courierId'] as String?,
      status: json['status'] as String?,
      deliveryPrice: (json['deliveryPrice'] as num?)?.toInt(),
      sdacha: (json['sdacha'] as num?)?.toInt(),
      amountToReduce: (json['amountToReduce'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$OrderDetailModelImplToJson(
        _$OrderDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhone': instance.userPhone,
      'orderNumber': instance.orderNumber,
      'dishesCount': instance.dishesCount,
      'foods': instance.foods,
      'address': instance.address,
      'houseNumber': instance.houseNumber,
      'kvOffice': instance.kvOffice,
      'intercom': instance.intercom,
      'floor': instance.floor,
      'entrance': instance.entrance,
      'comment': instance.comment,
      'paymentMethod': instance.paymentMethod,
      'price': instance.price,
      'timeRequest': instance.timeRequest,
      'courierId': instance.courierId,
      'status': instance.status,
      'deliveryPrice': instance.deliveryPrice,
      'sdacha': instance.sdacha,
      'amountToReduce': instance.amountToReduce,
    };
