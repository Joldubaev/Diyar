import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/ordering/delivery/domain/entities/entities.dart';

abstract class OrderRepository {
  Future<Either<Failure, String>> createOrder(CreateOrderEntity order);
}
