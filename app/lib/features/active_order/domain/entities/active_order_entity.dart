import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:equatable/equatable.dart';

class ActiveOrderEntity extends Equatable {
  final OrderActiveItemEntity? order;
  final String? courierName;
  final String? courierNumber;

  const ActiveOrderEntity({
    this.order,
    this.courierName,
    this.courierNumber,
  });

  @override
  List<Object?> get props => [
        order,
        courierName,
        courierNumber,
      ];
}
