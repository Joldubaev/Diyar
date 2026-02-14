
import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/active_order/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class CancelOrderUseCase {
  final ActiveOrderRepository _repository;

  CancelOrderUseCase(this._repository);

  Future<Either<Failure, void>> call({required int orderNumber, required bool isPickup}) {
    return _repository.cancelOrder(orderNumber: orderNumber, isPickup: isPickup);
  }
}