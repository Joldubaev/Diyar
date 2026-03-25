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

  const GetHistoryOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

final class GetHistoryOrdersError extends HistoryState {
  const GetHistoryOrdersError();
}

final class GetPickupHistoryLoading extends HistoryState {
  const GetPickupHistoryLoading();
}

final class GetPickupHistoryLoaded extends HistoryState {
  final PickupHistoryResponseEntity response;

  const GetPickupHistoryLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class GetPickupHistoryError extends HistoryState {
  const GetPickupHistoryError();
}
