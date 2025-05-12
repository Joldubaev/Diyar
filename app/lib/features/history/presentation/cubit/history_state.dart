part of 'history_cubit.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class GetHistoryOrdersLoading extends HistoryState {}

final class GetHistoryOrdersLoaded extends HistoryState {
  final List<OrderActiveItemEntity> orders;

  GetHistoryOrdersLoaded(this.orders);
}

final class GetHistoryOrdersError extends HistoryState {}

// get history orders

final class GetPickupHistoryLoading extends HistoryState {}

final class GetPickupHistoryLoaded extends HistoryState {
  final List<UserPickupHistoryEntity> orders;

  GetPickupHistoryLoaded(this.orders);
}

final class GetPickupHistoryError extends HistoryState {}
