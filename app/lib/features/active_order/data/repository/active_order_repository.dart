import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/core/mixins/repository_error_handler.dart';
import 'package:diyar/features/active_order/data/data.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:injectable/injectable.dart';
// features/active_order/data/repositories/active_order_repository_impl.dart

@LazySingleton(as: ActiveOrderRepository)
class ActiveOrderRepositoryImpl with RepositoryErrorHandler implements ActiveOrderRepository {
  final ActiveOrderRemoteDataSource _dataSource;

  ActiveOrderRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<OrderActiveItemEntity>>> getActiveOrders() {
    return makeRequest(() async {
      final models = await _dataSource.getActiveOrders();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, void>> cancelOrder({required int orderNumber, required bool isPickup}) {
    return makeRequest(() async {
      await _dataSource.cancelOrder(orderNumber: orderNumber, isPickup: isPickup);
    });
  }
}
