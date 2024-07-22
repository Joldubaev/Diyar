part of 'history_cubit.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class GetOrderItemLoading extends HistoryState {}

final class GetOrderItemLoaded extends HistoryState {
  final OrderActiveItemModel order;

  GetOrderItemLoaded(this.order);
}

final class GetOrderItemError extends HistoryState {}

final class GetActiveOrdersLoading extends HistoryState {}

final class GetActiveOrdersLoaded extends HistoryState {
  final List<ActiveOrderModel> orders;

  GetActiveOrdersLoaded(this.orders);
}

final class GetActiveOrdersError extends HistoryState {}

final class GetHistoryOrdersLoading extends HistoryState {}

final class GetHistoryOrdersLoaded extends HistoryState {
  final List<OrderActiveItemModel> orders;

  GetHistoryOrdersLoaded(this.orders);
}

final class GetHistoryOrdersError extends HistoryState {}

// get history orders

final class GetPickupHistoryLoading extends HistoryState {}

final class GetPickupHistoryLoaded extends HistoryState {
  final List<UserPickupHistoryModel> orders;

  GetPickupHistoryLoaded(this.orders);
}

final class GetPickupHistoryError extends HistoryState {}
