import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/data/data.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl with RepositoryErrorHandler implements HistoryRepository {
  final HistoryReDatasource historyReDatasource;
  HistoryRepositoryImpl(this.historyReDatasource);

  @override
  Future<Either<Failure, List<OrderActiveItemEntity>>> getHistoryOrders() {
    return makeRequest(() async {
      final models = await historyReDatasource.getHistoryOrders();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, PickupHistoryResponseEntity>> getPickupHistory({int pageNumber = 1, int pageSize = 10}) {
    return makeRequest(() async {
      final responseModel =
          await historyReDatasource.getPickupHistory(pageNumber: pageNumber, pageSize: pageSize);
      return PickupHistoryResponseEntity(
        orders: responseModel.orders.map((model) => model.toEntity()).toList(),
        totalCount: responseModel.totalCount,
        currentPage: responseModel.currentPage,
        pageSize: responseModel.pageSize,
        totalPages: responseModel.totalPages,
      );
    });
  }
}
