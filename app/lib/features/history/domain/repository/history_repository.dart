import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:fpdart/fpdart.dart' show Either;

abstract class HistoryRepository {
  Future<Either<Failure, List<OrderActiveItemEntity>>> getHistoryOrders();
  Future<Either<Failure, PickupHistoryResponseEntity>> getPickupHistory({int pageNumber = 1, int pageSize = 10});
}