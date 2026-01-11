import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/data/data.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryReDatasource historyReDatasource;
  HistoryRepositoryImpl(this.historyReDatasource);

  @override
  Future<List<OrderActiveItemEntity>> getHistoryOrders() async {
    final models = await historyReDatasource.getHistoryOrders();
    // Просто возвращай пустой список, если models.isEmpty
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PickupHistoryResponseEntity> getPickupHistory({int pageNumber = 1, int pageSize = 10}) async {
    final PickupHistoryResponseModel responseModel =
        await historyReDatasource.getPickupHistory(pageNumber: pageNumber, pageSize: pageSize);
    return PickupHistoryResponseEntity(
      orders: responseModel.orders.map((model) => model.toEntity()).toList(),
      totalCount: responseModel.totalCount,
      currentPage: responseModel.currentPage,
      pageSize: responseModel.pageSize,
      totalPages: responseModel.totalPages,
    );
  }
}
