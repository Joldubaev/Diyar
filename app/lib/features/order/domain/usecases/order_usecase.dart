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
    // Бонусы сравниваются с полной стоимостью заказа (price + deliveryPrice)
    if (order.amountToReduce != null && order.amountToReduce! > 0) {
      final totalOrderPrice = order.price + order.deliveryPrice;
      if (order.amountToReduce! > totalOrderPrice) {
        return const Left(ServerFailure('Сумма бонусов не может превышать стоимость заказа'));
      }
    }

    // 3. Логика сдачи (только для наличных)
    // Сдача сравнивается с полной суммой заказа (без вычитания бонусов)
    if (order.paymentMethod == 'cash' && order.sdacha != null) {
      if (order.sdacha! < (order.price + order.deliveryPrice)) {
        return const Left(ServerFailure('Сумма сдачи меньше итоговой стоимости заказа'));
      }
    }

    // Если все проверки пройдены — отправляем в репозиторий
    return await _repository.createOrder(order);
  }
}