part of 'curier_cubit.dart';

@immutable
sealed class CurierState {}

final class CurierInitial extends CurierState {}

final class GetCourierActualOrdersLoading extends CurierState {}

final class GetCourierActualOrdersLoaded extends CurierState {
  final List<CurierOrderModel> curiers;

  GetCourierActualOrdersLoaded(this.curiers);
}

final class GetCourierActualOrdersError extends CurierState {
  final String message;

  GetCourierActualOrdersError(this.message);
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
