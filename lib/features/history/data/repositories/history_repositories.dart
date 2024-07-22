import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/features/history/history.dart';

abstract class HistoryRepository {
  Future<OrderActiveItemModel> getOrderItem({required int orderNumber});
  Future<List<ActiveOrderModel>> getActiveOrders();
  Future<List<OrderActiveItemModel>> getHistoryOrders();
  Future<List<UserPickupHistoryModel>> getPickupHistory();
}

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryReDatasource historyReDatasource;
  HistoryRepositoryImpl(this.historyReDatasource);

  @override
  Future<OrderActiveItemModel> getOrderItem({required int orderNumber}) {
    return historyReDatasource.getOrderItem(num: orderNumber);
  }

  @override
  Future<List<ActiveOrderModel>> getActiveOrders() {
    return historyReDatasource.getActiveOrders();
  }

  @override
  Future<List<OrderActiveItemModel>> getHistoryOrders() {
    return historyReDatasource.getHistoryOrders();
  }

  @override
  Future<List<UserPickupHistoryModel>> getPickupHistory() {
    return historyReDatasource.getPickupHistory();
  }
}
