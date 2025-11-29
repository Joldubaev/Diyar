// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mega_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MegaCheckModelImpl _$$MegaCheckModelImplFromJson(Map<String, dynamic> json) =>
    _$MegaCheckModelImpl(
      commission: (json['commission'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MegaCheckModelImplToJson(
        _$MegaCheckModelImpl instance) =>
    <String, dynamic>{
      'commission': instance.commission,
      'amount': instance.amount,
    };
