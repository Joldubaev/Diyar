import 'package:bloc/bloc.dart';
import '../../data/data.dart';
import '../../data/model/user_pickup_history_model.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.historyRepository) : super(HistoryInitial());

  final HistoryRepository historyRepository;

  void getOrderItem(String orderNumber) async {
    emit(GetOrderItemLoading());
    try {
      final model = await historyRepository.getOrderItem(
        orderNumber: int.parse(orderNumber),
      );
      emit(GetOrderItemLoaded(model));
    } catch (e) {
      emit(GetOrderItemError());
    }
  }

  getActiveOrders() async {
    emit(GetActiveOrdersLoading());
    try {
      final orders = await historyRepository.getActiveOrders();
      emit(GetActiveOrdersLoaded(orders));
    } catch (e) {
      emit(GetActiveOrdersError());
    }
  }

  getHistoryOrders() async {
    emit(GetHistoryOrdersLoading());
    try {
      final orders = await historyRepository.getHistoryOrders();
      emit(GetHistoryOrdersLoaded(orders));
    } catch (e) {
      emit(GetHistoryOrdersError());
    }
  }

  getPickupHistory() async {
    emit(GetPickupHistoryLoading());
    try {
      final orders = await historyRepository.getPickupHistory();
      emit(GetPickupHistoryLoaded(orders));
    } catch (e) {
      emit(GetPickupHistoryError());
    }
  }
}
