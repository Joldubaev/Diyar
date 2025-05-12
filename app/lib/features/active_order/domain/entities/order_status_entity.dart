import 'package:equatable/equatable.dart';

class OrderStatusEntity extends Equatable {
  final int? orderNumber;
  final String? status;

  const OrderStatusEntity({
    this.orderNumber,
    this.status,
  });

  @override
  List<Object?> get props => [orderNumber, status];
}
