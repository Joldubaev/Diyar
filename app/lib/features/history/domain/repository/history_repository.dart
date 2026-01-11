import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';

abstract class HistoryRepository {
  Future<List<OrderActiveItemEntity>> getHistoryOrders();
  Future<PickupHistoryResponseEntity> getPickupHistory({int pageNumber = 1, int pageSize = 10});
}