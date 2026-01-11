import 'package:bloc/bloc.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

@injectable
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

  Future<void> getPickupHistory({int pageNumber = 1, int pageSize = 10}) async {
    emit(GetPickupHistoryLoading());
    try {
      final response = await historyRepository.getPickupHistory(pageNumber: pageNumber, pageSize: pageSize);
      emit(GetPickupHistoryLoaded(response));
    } catch (e) {
      emit(GetPickupHistoryError());
    }
  }
}
