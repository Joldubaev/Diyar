import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_status_model.freezed.dart';

@freezed
class OrderStatusModel with _$OrderStatusModel {
  const factory OrderStatusModel({
    int? orderNumber,
    String? status,
  }) = _OrderStatusModel;

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      orderNumber: (json['orderNumber'] as num?)?.toInt(),
      // Fallback: проверяем оба ключа 'status' и 'orderStatus'
      status: json['status'] as String? ?? json['orderStatus'] as String?,
    );
  }

  factory OrderStatusModel.fromEntity(OrderStatusEntity entity) => OrderStatusModel(
        orderNumber: entity.orderNumber,
        status: entity.status,
      );
}

extension OrderStatusModelX on OrderStatusModel {
  OrderStatusEntity toEntity() => OrderStatusEntity(
        orderNumber: orderNumber,
        status: status,
      );
}
