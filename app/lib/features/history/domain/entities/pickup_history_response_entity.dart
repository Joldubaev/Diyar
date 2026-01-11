import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_pickup_history_entity.dart';

part 'pickup_history_response_entity.freezed.dart';

@freezed
class PickupHistoryResponseEntity with _$PickupHistoryResponseEntity {
  const factory PickupHistoryResponseEntity({
    required List<UserPickupHistoryEntity> orders,
    required int totalCount,
    required int currentPage,
    required int pageSize,
    required int totalPages,
  }) = _PickupHistoryResponseEntity;
}
