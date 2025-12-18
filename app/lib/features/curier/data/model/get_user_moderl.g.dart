// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_moderl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetUserModelImpl _$$GetUserModelImplFromJson(Map<String, dynamic> json) =>
    _$GetUserModelImpl(
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      discount: (json['discount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GetUserModelImplToJson(_$GetUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'discount': instance.discount,
    };
