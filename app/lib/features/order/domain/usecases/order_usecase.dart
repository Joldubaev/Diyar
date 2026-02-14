import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<Either<Failure, String>> call(CreateOrderEntity order) async {
    // 1. Проверка на пустую корзину
    if (order.foods.isEmpty) {
      return const Left(ServerFailure('Корзина пуста'));
    }

    // 2. Логика бонусов
    // order.price уже содержит полную сумму (subtotalPrice + deliveryPrice)
    // Бонусы сравниваются с полной стоимостью заказа
    if (order.amountToReduce != null && order.amountToReduce! > 0) {
      if (order.amountToReduce! > order.price) {
        return const Left(ServerFailure('Сумма бонусов не может превышать стоимость заказа'));
      }
    }

    // 3. Логика сдачи (только для наличных)
    // Сдача сравнивается с полной суммой заказа (без вычитания бонусов)
    // order.price уже содержит полную сумму (subtotalPrice + deliveryPrice)
    if (order.paymentMethod == 'cash' && order.sdacha != null) {
      if (order.sdacha! < order.price) {
        return const Left(ServerFailure('Сумма сдачи меньше итоговой стоимости заказа'));
      }
    }

    // Если все проверки пройдены — отправляем в репозиторий
    return await _repository.createOrder(order);
  }
}
