import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:diyar/features/history/history.dart';
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
  Future<List<UserPickupHistoryEntity>> getPickupHistory() async {
    final models = await historyReDatasource.getPickupHistory();
    return models.map((model) => model.toEntity()).toList();
  }
}
