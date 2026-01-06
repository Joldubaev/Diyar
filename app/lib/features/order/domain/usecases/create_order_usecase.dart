import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/create_order_entity.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:injectable/injectable.dart';

/// UseCase для создания заказа
@injectable
class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<Either<Failure, String>> call(CreateOrderEntity order) {
    return _repository.createOrder(order);
  }
}

