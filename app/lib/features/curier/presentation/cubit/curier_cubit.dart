import 'package:bloc/bloc.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/curier/domain/domain.dart';
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
  ) : super(const UserInitial());

  final CurierRepository _repository;
  final ConfirmCashPaymentAndFinishUseCase _confirmCashPaymentAndFinishUseCase;
  final SharedPreferences _prefs;

  Future<void> getUser() async {
    emit(const UserLoading());

    final userResult = await _repository.getUser();
    if (userResult.isLeft()) {
      userResult.fold((f) => emit(UserError(f.message)), (_) {});
      return;
    }
    final user = userResult.getOrElse(() => throw StateError('user'));

    final shiftResult = await _repository.getShiftStatus();
    final isOnShift = shiftResult.fold(
      (_) => _prefs.getBool(AppConst.courierOnShift) ?? true,
      (v) => v,
    );
    await _prefs.setBool(AppConst.courierOnShift, isOnShift);
    emit(CurierMainState(user: user, isOnShift: isOnShift));
  }

  /// Выход на смену (true) / уход со смены (false). REST: POST /courier/shift.
  Future<bool> setOnShift(bool onShift) async {
    final result = await _repository.setShift(onShift);
    if (result.isLeft()) return false;
    await _prefs.setBool(AppConst.courierOnShift, onShift);
    final current = state;
    if (current is CurierMainState) {
      emit(current.copyWith(isOnShift: onShift));
    }
    return true;
  }

  /// Загружает активные заказы (не перетирает историю)
  Future<void> getCurierOrders() async {
    final user = state.user;
    if (user == null) return;

    final currentState = state is CurierMainState ? state as CurierMainState : CurierMainState(user: user);

    emit(currentState.copyWith(isActiveOrdersLoading: true, clearActiveOrdersError: true));

    final result = await _repository.getCurierOrders();
    result.fold(
      (failure) => emit(currentState.copyWith(
        isActiveOrdersLoading: false,
        activeOrdersError: failure.message,
      )),
      (orders) => emit(currentState.copyWith(
        isActiveOrdersLoading: false,
        activeOrders: orders,
        clearActiveOrdersError: true,
      )),
    );
  }

  /// Загружает историю заказов (не перетирает активные заказы)
  Future<void> getCurierHistory({
    String? startDate,
    String? endDate,
    bool loadMore = false,
  }) async {
    final user = state.user;
    if (user == null) return;

    final currentState = state is CurierMainState ? state as CurierMainState : CurierMainState(user: user);

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
    result.fold(
      (failure) => emit(currentState.copyWith(
        isHistoryLoading: false,
        isHistoryLoadingMore: false,
        historyError: failure.message,
      )),
      (newOrders) {
        final allOrders = loadMore ? [...existingOrders, ...newOrders] : newOrders;
        final sortedOrders = _sortOrdersByDate(allOrders);
        final hasMore = newOrders.length >= CurierConstants.historyPageSize;
        emit(currentState.copyWith(
          isHistoryLoading: false,
          isHistoryLoadingMore: false,
          historyOrders: sortedOrders,
          historyHasMore: hasMore,
          historyCurrentPage: nextPage,
          clearHistoryError: true,
        ));
      },
    );
  }

  /// Завершает заказ: для наличных — сначала отмечает оплату, потом завершает.
  /// Для безналичных — сразу завершает. Логика выбора вынесена сюда из UI.
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

    emit(FinishOrderLoading(user: user));

    final result = await _confirmCashPaymentAndFinishUseCase(order);
    result.fold(
      (failure) => emit(FinishOrderError(message: failure.message, user: user)),
      (_) => getCurierOrders(),
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
