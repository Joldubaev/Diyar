import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/features/order/order.dart';
import 'package:injectable/injectable.dart';

/// Результат валидации данных заказа
class OrderValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int calculatedChange;
  final int totalOrderCost;

  const OrderValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.calculatedChange,
    required this.totalOrderCost,
  });
}

/// UseCase для валидации данных заказа и расчета итоговых сумм
@injectable
class ValidateOrderDataUseCase {
  final OrderCalculationService _calculationService;

  ValidateOrderDataUseCase(this._calculationService);

  /// Валидирует данные заказа и рассчитывает итоговые суммы
  /// Бизнес-логика валидации: проверяет правила, использует Service для расчетов
  ///
  /// [subtotalPrice] - стоимость товаров без доставки
  /// [deliveryPrice] - стоимость доставки
  /// [paymentType] - тип оплаты
  /// [changeAmount] - сумма сдачи (null если не нужна)
  OrderValidationResult call({
    required int subtotalPrice,
    required double deliveryPrice,
    required PaymentTypeDelivery paymentType,
    int? changeAmount,
  }) {
    // Используем Service для расчета итоговой стоимости заказа
    final totalOrderCost = _calculationService
        .calculateFinalTotalPrice(
          subtotalPrice: subtotalPrice.toDouble(),
          deliveryPrice: deliveryPrice,
        )
        .toInt();

    // Бизнес-валидация для наличной оплаты
    if (paymentType == PaymentTypeDelivery.cash) {
      // Правило: для наличной оплаты должна быть выбрана сумма сдачи
      if (changeAmount == null) {
        return OrderValidationResult(
          isValid: false,
          errorMessage: 'Пожалуйста, выберите сумму сдачи',
          calculatedChange: 0,
          totalOrderCost: totalOrderCost,
        );
      }

      // Используем Service для расчета сдачи
      final calculatedChange = _calculationService.calculateChange(
        totalOrderCost,
        changeAmount,
      );

      // Правило: сдача не может быть отрицательной
      if (calculatedChange < 0) {
        return OrderValidationResult(
          isValid: false,
          errorMessage: 'Сдача не может быть меньше суммы',
          calculatedChange: calculatedChange,
          totalOrderCost: totalOrderCost,
        );
      }

      return OrderValidationResult(
        isValid: true,
        calculatedChange: calculatedChange,
        totalOrderCost: totalOrderCost,
      );
    }

    // Для онлайн оплаты валидация не требуется
    return OrderValidationResult(
      isValid: true,
      calculatedChange: 0,
      totalOrderCost: totalOrderCost,
    );
  }
}
