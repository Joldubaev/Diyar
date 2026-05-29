import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/core/error/failures.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'curier_state.dart';

@injectable
class CurierCubit extends Cubit<CurierState> {
  CurierCubit(
    this._repository,
    this._confirmCashPaymentAndFinishUseCase,
    this._prefs,
    this._locationHub,
  ) : super(const UserInitial()) {
    _myOrdersSub = _locationHub.ordersStream.listen(_onHubMyOrders);
    _orderAssignedSub = _locationHub.orderAssignedStream.listen(_onHubOrderAssigned);
    _orderDeliveredSub = _locationHub.orderDeliveredStream.listen(_onHubOrderDelivered);
  }

  final CurierRepository _repository;
  final ConfirmCashPaymentAndFinishUseCase _confirmCashPaymentAndFinishUseCase;
  final SharedPreferences _prefs;
  final CourierLocationHubService _locationHub;

  StreamSubscription<List<CurierEntity>>? _myOrdersSub;
  StreamSubscription<CurierEntity>? _orderAssignedSub;
  StreamSubscription<int>? _orderDeliveredSub;

  // ─── Hub event handlers ────────────────────────────────────────────────────

  void _onHubMyOrders(List<CurierEntity> orders) {
    final current = state;
    if (current is! CurierMainState) return;
    emit(current.copyWith(
      activeOrders: orders,
      isActiveOrdersLoading: false,
      clearActiveOrdersError: true,
    ));
  }

  void _onHubOrderAssigned(CurierEntity order) {
    final current = state;
    if (current is! CurierMainState) return;
    if (current.activeOrders.any((o) => o.orderNumber == order.orderNumber)) return;
    emit(current.copyWith(activeOrders: [...current.activeOrders, order]));
  }

  void _onHubOrderDelivered(int orderNumber) {
    final current = state;
    if (current is! CurierMainState) return;
    emit(current.copyWith(
      activeOrders: current.activeOrders
          .where((o) => o.orderNumber != orderNumber)
          .toList(),
    ));
  }

  // ─── Public methods ────────────────────────────────────────────────────────

  Future<void> getUser() async {
    emit(const UserLoading());

    final userResult = await _repository.getUser();
    if (isClosed) return;

    final user = userResult.fold(
      (f) {
        final isAuth = f is ServerFailure &&
            (f.statusCode == 401 || f.statusCode == 403);
        emit(UserError(f.message, isAuthError: isAuth));
        return null;
      },
      (u) => u,
    );
    if (user == null) return;

    final shiftResult = await _repository.getShiftStatus();
    if (isClosed) return;
    final isOnShift = shiftResult.fold(
      (_) => _prefs.getBool(AppConst.courierOnShift) ?? true,
      (v) => v,
    );
    await _prefs.setBool(AppConst.courierOnShift, isOnShift);
    if (isClosed) return;
    emit(CurierMainState(user: user, isOnShift: isOnShift));
  }

  /// Выход на смену (true) / уход со смены (false).
  /// Уведомляет и REST и хаб, чтобы диспетчер мог назначать заказы.
  /// Запускает / останавливает foreground service для фоновой геолокации.
  Future<bool> setOnShift(bool onShift) async {
    final result = await _repository.setShift(onShift);
    if (isClosed) return false;
    if (result.isLeft()) return false;
    await _prefs.setBool(AppConst.courierOnShift, onShift);
    if (isClosed) return false;

    if (onShift) {
      unawaited(CourierForegroundService.start());
    } else {
      unawaited(CourierForegroundService.stop());
    }

    await _locationHub.setOnShift(onShift);
    final current = state;
    if (current is CurierMainState) {
      emit(current.copyWith(isOnShift: onShift));
    }
    return true;
  }

  /// Загружает активные заказы через REST (ручное обновление / fallback).
  /// Реальное время обеспечивается хабом через [_onHubMyOrders] и [_onHubOrderAssigned].
  /// [silent] — при ошибке не показывает её если заказы уже загружены.
  Future<void> getCurierOrders({bool silent = false}) async {
    final user = state.user;
    if (user == null) return;

    final currentState = _requireMainState(user);
    emit(currentState.copyWith(isActiveOrdersLoading: true, clearActiveOrdersError: true));

    final result = await _repository.getCurierOrders();
    if (isClosed) return;

    // Re-read state after await: concurrent hub events may have updated it.
    final latestState = state is CurierMainState ? state as CurierMainState : currentState;

    result.fold(
      (failure) {
        if (silent && latestState.activeOrders.isNotEmpty) {
          emit(latestState.copyWith(isActiveOrdersLoading: false));
        } else {
          emit(latestState.copyWith(
            isActiveOrdersLoading: false,
            activeOrdersError: failure.message,
          ));
        }
      },
      (orders) => emit(latestState.copyWith(
        isActiveOrdersLoading: false,
        activeOrders: orders,
        clearActiveOrdersError: true,
      )),
    );
  }

  /// Загружает историю заказов (не перетирает активные заказы).
  Future<void> getCurierHistory({
    String? startDate,
    String? endDate,
    bool loadMore = false,
  }) async {
    final user = state.user;
    if (user == null) return;

    final currentState = _requireMainState(user);
    final currentPage = loadMore ? currentState.historyCurrentPage : 0;
    final existingOrders = loadMore ? currentState.historyOrders : <CurierEntity>[];

    emit(currentState.copyWith(
      isHistoryLoading: !loadMore,
      isHistoryLoadingMore: loadMore,
      clearHistoryError: true,
    ));

    final nextPage = loadMore ? currentPage + 1 : 1;
    final result = await _repository.getCurierHistory(
      startDate: startDate,
      endDate: endDate,
      page: nextPage,
      pageSize: CurierConstants.historyPageSize,
    );
    if (isClosed) return;

    // Re-read state after await to avoid overwriting concurrent changes.
    final latestState = state is CurierMainState ? state as CurierMainState : currentState;

    result.fold(
      (failure) => emit(latestState.copyWith(
        isHistoryLoading: false,
        isHistoryLoadingMore: false,
        historyError: failure.message,
      )),
      (newOrders) {
        final allOrders = loadMore ? [...existingOrders, ...newOrders] : newOrders;
        emit(latestState.copyWith(
          isHistoryLoading: false,
          isHistoryLoadingMore: false,
          historyOrders: _sortOrdersByDate(allOrders),
          historyHasMore: newOrders.length >= CurierConstants.historyPageSize,
          historyCurrentPage: nextPage,
          clearHistoryError: true,
        ));
      },
    );
  }

  /// Завершает заказ: для наличных — сначала отмечает оплату, потом завершает.
  Future<void> finishOrder(CurierEntity order) async {
    final method = PaymentMethod.fromString(order.paymentMethod);
    if (method.isCash) {
      await confirmCashPaymentAndFinish(order);
    } else {
      await getFinishOrder(order.orderNumber ?? 0);
    }
  }

  Future<void> getFinishOrder(int orderId) async {
    final user = state.user;
    if (user == null) return;

    final currentMainState = state is CurierMainState ? state as CurierMainState : null;
    emit(FinishOrderLoading(user: user));

    final result = await _repository.getFinishOrder(orderId);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (currentMainState != null) {
          emit(currentMainState.copyWith(activeOrdersError: failure.message));
        } else {
          emit(FinishOrderError(message: failure.message, user: user));
        }
      },
      (_) {
        if (currentMainState != null) {
          emit(currentMainState);
          // Hub will push OrderDelivered to remove the order; REST is a fallback.
          getCurierOrders();
        } else {
          emit(FinishOrderSuccess(user: user));
        }
      },
    );
  }

  Future<void> confirmCashPaymentAndFinish(CurierEntity order) async {
    final user = state.user;
    if (user == null) return;

    // Saved before emit so we can restore it on success (same pattern as getFinishOrder).
    final currentMainState = state is CurierMainState ? state as CurierMainState : null;
    emit(FinishOrderLoading(user: user));

    final result = await _confirmCashPaymentAndFinishUseCase(order);
    if (isClosed) return;
    result.fold(
      (failure) => emit(FinishOrderError(message: failure.message, user: user)),
      (_) {
        if (currentMainState != null) emit(currentMainState);
        getCurierOrders();
      },
    );
  }

  /// Курьер забрал заказ из ресторана → PUT /courier/order/start-delivery.
  Future<void> startDelivery(int orderNumber) async {
    final user = state.user;
    if (user == null) return;

    final currentMainState = state is CurierMainState ? state as CurierMainState : null;
    emit(FinishOrderLoading(user: user));

    final result = await _repository.startDelivery(orderNumber);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (currentMainState != null) {
          emit(currentMainState.copyWith(activeOrdersError: failure.message));
        } else {
          emit(FinishOrderError(message: failure.message, user: user));
        }
      },
      (_) {
        emit(StartDeliverySuccess(user: user));
        getCurierOrders();
      },
    );
  }

  @override
  Future<void> close() async {
    await _myOrdersSub?.cancel();
    await _orderAssignedSub?.cancel();
    await _orderDeliveredSub?.cancel();
    return super.close();
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Returns current [CurierMainState] or builds a fallback with isOnShift from prefs.
  CurierMainState _requireMainState(GetUserEntity user) {
    if (state is CurierMainState) return state as CurierMainState;
    return CurierMainState(
      user: user,
      isOnShift: _prefs.getBool(AppConst.courierOnShift) ?? true,
    );
  }

  List<CurierEntity> _sortOrdersByDate(List<CurierEntity> orders) {
    return List.from(orders)
      ..sort((a, b) {
        final dateA = a.timeRequest.parseOrderDateTime();
        final dateB = b.timeRequest.parseOrderDateTime();
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });
  }
}
