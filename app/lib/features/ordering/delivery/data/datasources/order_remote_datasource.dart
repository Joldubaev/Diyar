import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/ordering/delivery/data/models/model.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, String>> createOrder(CreateOrderModel order);
}
