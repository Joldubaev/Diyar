import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveOrdersUseCase {
  final ActiveOrderRepository _repository;

  GetActiveOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderActiveItemEntity>>> call() {
    return _repository.getActiveOrders();
  }
}