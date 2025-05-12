part of 'active_order_cubit.dart';

sealed class ActiveOrderState extends Equatable {
  const ActiveOrderState();

  @override
  List<Object> get props => [];
}

final class ActiveOrderInitial extends ActiveOrderState {}

final class ActiveOrdersLoading extends ActiveOrderState {}

final class ActiveOrdersLoaded extends ActiveOrderState {
  final List<ActiveOrderEntity> orders;

  const ActiveOrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class ActiveOrdersError extends ActiveOrderState {
  final String message;

  const ActiveOrdersError(this.message);

  @override
  List<Object> get props => [message];
}

final class OrderItemLoading extends ActiveOrderState {}

final class OrderItemLoaded extends ActiveOrderState {
  final OrderActiveItemEntity order;

  const OrderItemLoaded(this.order);

  @override
  List<Object> get props => [order];
}

final class OrderItemError extends ActiveOrderState {
  final String message;

  const OrderItemError(this.message);

  @override
  List<Object> get props => [message];
}
