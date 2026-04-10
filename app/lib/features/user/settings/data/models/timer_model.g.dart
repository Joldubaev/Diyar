// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerModelImpl _$$TimerModelImplFromJson(Map<String, dynamic> json) =>
    _$TimerModelImpl(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isTechnicalWork: json['isTechnicalWork'] as bool?,
      serverTime: json['serverTime'] as String?,
    );

Map<String, dynamic> _$$TimerModelImplToJson(_$TimerModelImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isTechnicalWork': instance.isTechnicalWork,
      'serverTime': instance.serverTime,
    };
