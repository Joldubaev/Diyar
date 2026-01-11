import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_pickup_history_model.dart';

part 'pickup_history_response_model.freezed.dart';
part 'pickup_history_response_model.g.dart';

@freezed
class PickupHistoryResponseModel with _$PickupHistoryResponseModel {
  const factory PickupHistoryResponseModel({
    required List<UserPickupHistoryModel> orders,
    required int totalCount,
    required int currentPage,
    required int pageSize,
    required int totalPages,
  }) = _PickupHistoryResponseModel;

  factory PickupHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PickupHistoryResponseModelFromJson(json);
}
