import 'package:diyar/features/active_order/data/data.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ActiveOrderRepository)
class ActiveOrderRepositoryImpl implements ActiveOrderRepository {
  final ActiveOrderRemoteDataSource dataSource;

  ActiveOrderRepositoryImpl(this.dataSource);

  @override
  Future<OrderActiveItemEntity> getOrderItem({required int num}) async {
    final model = await dataSource.getOrderItem(num: num);
    return model.toEntity();
  }

  @override
  Future<List<OrderActiveItemEntity>> getActiveOrders() async {
    final models = await dataSource.getActiveOrders();
    return models.map((model) => model.toEntity()).toList();
  }
}
