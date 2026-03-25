import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:diyar/features/active_order/data/services/order_status_service.dart';
import 'package:diyar/features/active_order/domain/usecases/get_active_orders_usecase.dart';
import 'package:diyar/features/active_order/domain/usecases/cancel_order_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:injectable/injectable.dart';

part 'active_order_state.dart';

@LazySingleton()
class ActiveOrderCubit extends Cubit<ActiveOrderState> {
  static const _statusDebounceMs = 2000;

  // Статусы, при которых заказ считается активным (всё остальное — терминальное)
  static const _activeStatuses = {'Awaits', 'Processing', 'OnTheWay'};

  final GetActiveOrdersUseCase _getActiveOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final OrderStatusService _statusService;
  StreamSubscription? _statusSubscription;
  DateTime? _lastStatusEmit;

  ActiveOrderCubit(
    this._getActiveOrdersUseCase,
    this._cancelOrderUseCase,
    this._statusService,
  ) : super(ActiveOrderInitial());

  Future<void> getActiveOrders() async {
    // Если уже загружаем, не спамим запросами
    if (state is ActiveOrdersLoading) return;

    emit(ActiveOrdersLoading());

    final result = await _getActiveOrdersUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(ActiveOrdersError(failure.message)),
      (orders) {
        emit(ActiveOrdersLoaded(orders));
        _listenToStatusUpdates();
      },
    );
  }

  void _listenToStatusUpdates() {
    _statusSubscription?.cancel();
    _statusService.initAndConnect();

    _statusSubscription = _statusService.statusStream.listen(
      (newStatuses) {
        if (isClosed) return;

        final now = DateTime.now();
        if (_lastStatusEmit != null && now.difference(_lastStatusEmit!).inMilliseconds < _statusDebounceMs) {
          return;
        }
        _lastStatusEmit = now;

        final currentState = state;
        if (currentState is ActiveOrdersLoaded) {
          final updatedOrders = currentState.orders
              .map((order) {
                final statusUpdate = newStatuses.firstWhereOrNull(
                  (s) => s.orderNumber == order.orderNumber,
                );
                if (statusUpdate != null && statusUpdate.status != null) {
                  return order.copyWith(status: () => statusUpdate.status);
                }
                return order;
              })
              // Убираем заказы с терминальным статусом (доставлен, отменён и т.д.)
              .where((o) => o.status == null || _activeStatuses.contains(o.status))
              .toList();

          emit(ActiveOrdersLoaded(updatedOrders));
        }
      },
      onError: (e) => log('SignalR Stream Error: $e'),
    );
  }

  Future<void> cancelOrder(OrderActiveItemEntity order) async {
    if (order.orderNumber == null) return;

    final result = await _cancelOrderUseCase(
      orderNumber: order.orderNumber!,
      isPickup: order.isPickup,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ActiveOrdersError(failure.message)),
      (_) {
        // После отмены обновляем список заказов, чтобы убрать отмененный заказ
        getActiveOrders();
      },
    );
  }

  /// Сброс состояния при логауте (отменяет подписку SignalR и очищает данные)
  void reset() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
    _lastStatusEmit = null;
    emit(ActiveOrderInitial());
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    // ВАЖНО: Сервис сокетов лучше закрывать только если Cubit единственный его владелец
    _statusService.dispose();
    return super.close();
  }
}
