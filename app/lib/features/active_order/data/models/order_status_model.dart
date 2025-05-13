import 'package:diyar/features/active_order/domain/domain.dart';

class OrderStatusModel {
  final int orderNumber;
  final String status;

  OrderStatusModel({
    required this.orderNumber,
    required this.status,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      orderNumber: json['orderNumber'] as int,
      status: (json['status'] ?? json['orderStatus']) as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'status': status,
    };
  }

  factory OrderStatusModel.fromEntity(OrderStatusEntity entity) {
    return OrderStatusModel(
      orderNumber: entity.orderNumber ?? 0,
      status: entity.status ?? '',
    );
  }
  OrderStatusEntity toEntity() {
    return OrderStatusEntity(
      orderNumber: orderNumber,
      status: status,
    );
  }
}
