import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/ordering/detail/domain/entities/order_detail_entity.dart';

abstract interface class OrderDetailRepository {
  Future<Either<Failure, OrderDetailEntity>> getOrderDetail({required int orderNumber});
}
