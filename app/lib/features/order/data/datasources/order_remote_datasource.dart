import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/data/models/model.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, String>> createOrder(CreateOrderModel order);
}
