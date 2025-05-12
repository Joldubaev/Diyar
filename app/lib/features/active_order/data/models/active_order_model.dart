import 'package:diyar/features/active_order/data/data.dart';
import 'package:diyar/features/active_order/domain/domain.dart';

class ActiveOrderModel {
  final OrderActiveItemModel? order;
  final String? courierName;
  final String? courierNumber;

  ActiveOrderModel({
    this.order,
    this.courierName,
    this.courierNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'order': order?.toJson(),
      'courierName': courierName,
      'courierNumber': courierNumber,
    };
  }

  factory ActiveOrderModel.fromJson(Map<String, dynamic> map) {
    return ActiveOrderModel(
      order: map['order'] != null ? OrderActiveItemModel.fromJson(map['order']) : null,
      courierName: map['courierName'],
      courierNumber: map['courierNumber'],
    );
  }

  factory ActiveOrderModel.fromEntity(ActiveOrderEntity entity) {
    return ActiveOrderModel(
      order: entity.order != null ? OrderActiveItemModel.fromEntity(entity.order!) : null,
      courierName: entity.courierName,
      courierNumber: entity.courierNumber,
    );
  }
  ActiveOrderEntity toEntity() {
    return ActiveOrderEntity(
      order: order?.toEntity(),
      courierName: courierName,
      courierNumber: courierNumber,
    );
  }
}
