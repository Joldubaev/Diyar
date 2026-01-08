part of 'curier_cubit.dart';

sealed class CurierState {
  final GetUserEntity? user;
  const CurierState({this.user});
}

/* ================= USER ================= */

final class UserInitial extends CurierState {
  const UserInitial();
}

final class UserLoading extends CurierState {
  const UserLoading();
}

final class UserLoaded extends CurierState {
  const UserLoaded(GetUserEntity user) : super(user: user);
}

final class UserError extends CurierState {
  final String message;
  const UserError(this.message);
}

/* ================= ORDERS ================= */

final class OrdersLoading extends CurierState {
  const OrdersLoading({required GetUserEntity user}) : super(user: user);
}

final class OrdersLoaded extends CurierState {
  final List<CurierEntity> orders;

  const OrdersLoaded({
    required GetUserEntity user,
    required this.orders,
  }) : super(user: user);
}

final class OrdersError extends CurierState {
  final String message;

  const OrdersError({
    required this.message,
    required GetUserEntity user,
  }) : super(user: user);
}

/* ================= HISTORY ================= */

final class CurierHistoryLoading extends CurierState {
  const CurierHistoryLoading({required GetUserEntity user}) : super(user: user);
}

final class CurierHistoryLoaded extends CurierState {
  final List<CurierEntity> orders;
  final bool hasMore;
  final int currentPage;

  const CurierHistoryLoaded({
    required GetUserEntity user,
    required this.orders,
    this.hasMore = false,
    this.currentPage = 1,
  }) : super(user: user);
}

final class CurierHistoryLoadingMore extends CurierState {
  final List<CurierEntity> orders;
  final int currentPage;

  const CurierHistoryLoadingMore({
    required GetUserEntity user,
    required this.orders,
    required this.currentPage,
  }) : super(user: user);
}

final class CurierHistoryError extends CurierState {
  final String message;

  const CurierHistoryError({
    required this.message,
    required GetUserEntity user,
  }) : super(user: user);
}

final class FinishOrderLoading extends CurierState {
  const FinishOrderLoading({required GetUserEntity user}) : super(user: user);
}

final class FinishOrderSuccess extends CurierState {
  const FinishOrderSuccess({required GetUserEntity user}) : super(user: user);
}

final class FinishOrderError extends CurierState {
  final String message;

  const FinishOrderError({
    required this.message,
    required GetUserEntity user,
  }) : super(user: user);
}
