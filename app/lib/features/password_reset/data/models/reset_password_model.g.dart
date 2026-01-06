// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResetPasswordModelImpl _$$ResetPasswordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordModelImpl(
      phone: json['phone'] as String?,
      newPassword: json['newPassword'] as String?,
      code: (json['code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ResetPasswordModelImplToJson(
        _$ResetPasswordModelImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'newPassword': instance.newPassword,
      'code': instance.code,
    };
