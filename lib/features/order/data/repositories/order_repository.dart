import 'package:diyar/features/order/data/datasources/order_remote_datasource.dart';
import 'package:diyar/features/order/data/models/pickup_order_model.dart';
import 'package:diyar/features/order/order.dart';

abstract class OrderRepository {
  // Future<List<String>> getOrderHistory();
  Future<void> createOrder(CreateOrderModel order);
  Future<void> getPickupOrder(PickupOrderModel order);
}

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  // @override
  // Future<List<String>> getOrderHistory() async {
  //   return _orderDataSource.getOrderHistory();
  // }

  @override
  Future<void> createOrder(CreateOrderModel order) async {
    return _orderDataSource.createOrder(order);
  }

  @override
  Future<void> getPickupOrder(PickupOrderModel order) async {
    return _orderDataSource.getPickupOrder(order);
  }
}
