import 'package:bloc/bloc.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';

import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.historyRepository) : super(HistoryInitial());

  final HistoryRepository historyRepository;



 Future<void> getHistoryOrders() async {
  emit(GetHistoryOrdersLoading());
  try {
    final orders = await historyRepository.getHistoryOrders();
    // Не выбрасывай ошибку, если orders.isEmpty!
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
