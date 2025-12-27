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

@injectable
class ActiveOrderCubit extends Cubit<ActiveOrderState> {
  final GetActiveOrdersUseCase _getActiveOrdersUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final OrderStatusService _statusService;
  StreamSubscription? _statusSubscription;

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

        // Используем локальную переменную для фиксации состояния
        final currentState = state;
        if (currentState is ActiveOrdersLoaded) {
          final updatedOrders = currentState.orders.map((order) {
            // Ищем обновление статуса для конкретного заказа
            final statusUpdate = newStatuses.firstWhereOrNull(
              (s) => s.orderNumber == order.orderNumber,
            );

            if (statusUpdate != null && statusUpdate.status != null) {
              // Используем наш Senior copyWith с ValueGetter
              return order.copyWith(status: () => statusUpdate.status);
            }
            return order;
          }).toList();

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

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    // ВАЖНО: Сервис сокетов лучше закрывать только если Cubit единственный его владелец
    _statusService.dispose();
    return super.close();
  }
}
