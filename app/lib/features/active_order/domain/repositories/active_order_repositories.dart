import 'package:diyar/features/active_order/active_order.dart';

abstract interface class ActiveOrderRepository {
  Future<OrderActiveItemEntity> getOrderItem({required int num});
  Future<List<OrderActiveItemEntity>> getActiveOrders();
 
}