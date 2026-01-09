import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';

abstract class OrderRepository {
  Future<Either<Failure, String>> createOrder(CreateOrderEntity order);
}
