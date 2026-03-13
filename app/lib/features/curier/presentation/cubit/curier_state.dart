part of 'curier_cubit.dart';

abstract class CurierState extends Equatable {
  final GetUserEntity? user;
  final List<CurierEntity> activeOrders;
  final List<CurierEntity> historyOrders;
  final bool isActiveOrdersLoading;
  final bool isHistoryLoading;
  final bool isHistoryLoadingMore;
  final bool historyHasMore;
  final int historyCurrentPage;
  final String? activeOrdersError;
  final String? historyError;
  final bool isOnShift;

  const CurierState({
    this.user,
    this.activeOrders = const [],
    this.historyOrders = const [],
    this.isActiveOrdersLoading = false,
    this.isHistoryLoading = false,
    this.isHistoryLoadingMore = false,
    this.historyHasMore = false,
    this.historyCurrentPage = 1,
    this.activeOrdersError,
    this.historyError,
    this.isOnShift = true,
  });

  @override
  List<Object?> get props => [
        user,
        activeOrders,
        historyOrders,
        isActiveOrdersLoading,
        isHistoryLoading,
        isHistoryLoadingMore,
        historyHasMore,
        historyCurrentPage,
        activeOrdersError,
        historyError,
        isOnShift,
      ];

  CurierState copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  });
}

/* ================= USER ================= */

final class UserInitial extends CurierState {
  const UserInitial();

  @override
  UserInitial copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return UserInitial();
  }
}

final class UserLoading extends CurierState {
  const UserLoading();

  @override
  UserLoading copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return const UserLoading();
  }
}

final class UserLoaded extends CurierState {
  const UserLoaded(GetUserEntity user) : super(user: user);

  @override
  UserLoaded copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return UserLoaded(
      user ?? this.user!,
    );
  }
}

final class UserError extends CurierState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [...super.props, message];

  @override
  UserError copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return UserError(message);
  }
}

/* ================= MAIN STATE ================= */

/// Основное состояние с раздельными данными для активных заказов и истории
final class CurierMainState extends CurierState {
  const CurierMainState({
    required GetUserEntity super.user,
    super.activeOrders,
    super.historyOrders,
    super.isActiveOrdersLoading,
    super.isHistoryLoading,
    super.isHistoryLoadingMore,
    super.historyHasMore,
    super.historyCurrentPage,
    super.activeOrdersError,
    super.historyError,
    super.isOnShift = true,
  });

  @override
  CurierMainState copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return CurierMainState(
      user: user ?? this.user!,
      activeOrders: activeOrders ?? this.activeOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      isActiveOrdersLoading: isActiveOrdersLoading ?? this.isActiveOrdersLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      isHistoryLoadingMore: isHistoryLoadingMore ?? this.isHistoryLoadingMore,
      historyHasMore: historyHasMore ?? this.historyHasMore,
      historyCurrentPage: historyCurrentPage ?? this.historyCurrentPage,
      activeOrdersError: clearActiveOrdersError ? null : (activeOrdersError ?? this.activeOrdersError),
      historyError: clearHistoryError ? null : (historyError ?? this.historyError),
      isOnShift: isOnShift ?? this.isOnShift,
    );
  }
}

/* ================= FINISH ORDER ================= */

final class FinishOrderLoading extends CurierState {
  const FinishOrderLoading({required GetUserEntity user}) : super(user: user);

  @override
  FinishOrderLoading copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return FinishOrderLoading(user: user ?? this.user!);
  }
}

final class FinishOrderSuccess extends CurierState {
  const FinishOrderSuccess({required GetUserEntity user}) : super(user: user);

  @override
  FinishOrderSuccess copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return FinishOrderSuccess(user: user ?? this.user!);
  }
}

final class FinishOrderError extends CurierState {
  final String message;

  const FinishOrderError({
    required this.message,
    required GetUserEntity user,
  }) : super(user: user);

  @override
  List<Object?> get props => [...super.props, message];

  @override
  FinishOrderError copyWith({
    GetUserEntity? user,
    List<CurierEntity>? activeOrders,
    List<CurierEntity>? historyOrders,
    bool? isActiveOrdersLoading,
    bool? isHistoryLoading,
    bool? isHistoryLoadingMore,
    bool? historyHasMore,
    int? historyCurrentPage,
    String? activeOrdersError,
    String? historyError,
    bool? isOnShift,
    bool clearActiveOrdersError = false,
    bool clearHistoryError = false,
  }) {
    return FinishOrderError(
      message: message,
      user: user ?? this.user!,
    );
  }
}
