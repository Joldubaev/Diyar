import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:diyar/features/order/data/datasources/order_remote_datasource.dart';
import 'package:diyar/features/order/data/models/model.dart';
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
