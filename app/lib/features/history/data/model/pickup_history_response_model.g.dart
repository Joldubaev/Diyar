// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickup_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PickupHistoryResponseModelImpl _$$PickupHistoryResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PickupHistoryResponseModelImpl(
      orders: (json['orders'] as List<dynamic>)
          .map(
              (e) => UserPickupHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$PickupHistoryResponseModelImplToJson(
        _$PickupHistoryResponseModelImpl instance) =>
    <String, dynamic>{
      'orders': instance.orders,
      'totalCount': instance.totalCount,
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalPages': instance.totalPages,
    };
