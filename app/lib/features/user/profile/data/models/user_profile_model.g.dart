// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: json['id'] as String?,
      phone: json['phone'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      active: json['active'] as bool?,
      balance: (json['balance'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'userName': instance.userName,
      'email': instance.email,
      'role': instance.role,
      'active': instance.active,
      'balance': instance.balance,
      'discount': instance.discount,
    };
