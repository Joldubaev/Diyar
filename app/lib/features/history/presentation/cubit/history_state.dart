part of 'history_cubit.dart';

@immutable
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

final class GetHistoryOrdersLoading extends HistoryState {
  const GetHistoryOrdersLoading();
}

final class GetHistoryOrdersLoaded extends HistoryState {
  final List<OrderActiveItemEntity> orders;

  /// Активный фильтр по дате (null — показаны все заказы).
  final DateTimeRange? dateRange;

  const GetHistoryOrdersLoaded(this.orders, {this.dateRange});

  @override
  List<Object?> get props => [orders, dateRange];
}

final class GetHistoryOrdersError extends HistoryState {
  final String message;
  const GetHistoryOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

final class GetPickupHistoryLoading extends HistoryState {
  const GetPickupHistoryLoading();
}

final class GetPickupHistoryLoaded extends HistoryState {
  final PickupHistoryResponseEntity response;

  /// Активный фильтр по дате (null — показаны все заказы).
  final DateTimeRange? dateRange;

  const GetPickupHistoryLoaded(this.response, {this.dateRange});

  @override
  List<Object?> get props => [response, dateRange];
}

final class GetPickupHistoryError extends HistoryState {
  final String message;
  const GetPickupHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
