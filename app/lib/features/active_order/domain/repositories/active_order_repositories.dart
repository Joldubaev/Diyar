import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';

abstract interface class ActiveOrderRepository {
  Future<Either<Failure, List<OrderActiveItemEntity>>> getActiveOrders();
  Future<Either<Failure, void>> cancelOrder({required int orderNumber, required bool isPickup});
}
