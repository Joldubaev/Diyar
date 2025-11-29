import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_active_item_model.dart';

part 'active_order_model.freezed.dart';
part 'active_order_model.g.dart';

@freezed
class ActiveOrderModel with _$ActiveOrderModel {
  const factory ActiveOrderModel({
    OrderActiveItemModel? order,
    String? courierName,
    String? courierNumber,
  }) = _ActiveOrderModel;

  factory ActiveOrderModel.fromJson(Map<String, dynamic> json) => _$ActiveOrderModelFromJson(json);

  factory ActiveOrderModel.fromEntity(ActiveOrderEntity entity) => ActiveOrderModel(
        order: entity.order != null ? OrderActiveItemModel.fromEntity(entity.order!) : null,
        courierName: entity.courierName,
        courierNumber: entity.courierNumber,
      );
}

extension ActiveOrderModelX on ActiveOrderModel {
  ActiveOrderEntity toEntity() => ActiveOrderEntity(
        order: order?.toEntity(),
        courierName: courierName,
        courierNumber: courierNumber,
      );
}
