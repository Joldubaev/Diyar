import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/active_order/domain/domain.dart';

part 'active_order_state.dart';

class ActiveOrderCubit extends Cubit<ActiveOrderState> {
  final ActiveOrderRepository repository;
  ActiveOrderCubit(this.repository) : super(ActiveOrderInitial());

  Future<void> getActiveOrders() async {
    emit(ActiveOrdersLoading());
    try {
      final orders = await repository.getActiveOrders();
      emit(ActiveOrdersLoaded(orders));
    } catch (e) {
      emit(ActiveOrdersError(e.toString()));
    }
  }

  Future<void> getOrderItem(String orderNumber) async {
    emit(OrderItemLoading());
    try {
      final order = await repository.getOrderItem(
        num: int.parse(orderNumber),
      );
      emit(OrderItemLoaded(order));
    } catch (e) {
      emit(OrderItemError(e.toString()));
    }
  }
}
