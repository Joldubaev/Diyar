import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/ordering/delivery/domain/entities/entities.dart';
import 'package:diyar/features/ordering/delivery/domain/repositories/order_repositories.dart';
import 'package:diyar/features/ordering/delivery/data/datasources/order_remote_datasource.dart';
import 'package:diyar/features/ordering/delivery/data/models/model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderEntity orderEntity) async {
    final orderModel = CreateOrderModel.fromEntity(orderEntity);
    return await _orderDataSource.createOrder(orderModel);
  }
}
