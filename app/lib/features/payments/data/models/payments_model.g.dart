// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentsModelImpl _$$PaymentsModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentsModelImpl(
      orderNumber: json['orderNumber'] as String?,
      user: json['user'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      pinCode: json['pinCode'] as String?,
      otp: json['otp'] as String?,
    );

Map<String, dynamic> _$$PaymentsModelImplToJson(_$PaymentsModelImpl instance) =>
    <String, dynamic>{
      'orderNumber': instance.orderNumber,
      'user': instance.user,
      'amount': instance.amount,
      'pinCode': instance.pinCode,
      'otp': instance.otp,
    };
