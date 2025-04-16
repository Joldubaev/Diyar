part of 'curier_cubit.dart';

@immutable
sealed class CurierState {}

final class CurierInitial extends CurierState {}

final class GetCourierOrdersLoading extends CurierState {}

final class GetCourierOrdersLoaded extends CurierState {
  final List<CurierOrderModel> curiers;

  GetCourierOrdersLoaded(this.curiers);
}

final class GetCourierOrdersError extends CurierState {
  final String message;

  GetCourierOrdersError(this.message);
}

class GetCurierHistoryLoading extends CurierState {}

class GetCurierHistoryLoaded extends CurierState {
  final List<CurierOrderModel> curiers;

  GetCurierHistoryLoaded(this.curiers);
}

class GetCurierHistoryError extends CurierState {
  final String message;

  GetCurierHistoryError(this.message);
}

class GetUserLoading extends CurierState {}

class GetUserLoaded extends CurierState {
  final GetUserModel user;

  GetUserLoaded(this.user);
}

class GetUserError extends CurierState {
  final String message;

  GetUserError(this.message);
}

class GetFinishedOrdersLoading extends CurierState {}

class GetFinishedOrdersLoaded extends CurierState {}

class GetFinishedOrdersError extends CurierState {}
