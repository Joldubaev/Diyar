import 'package:bloc/bloc.dart';
import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/features/order/order.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'delivery_form_state.dart';

/// Cubit для управления состоянием формы доставки
/// Управляет бизнес-логикой формы: расчетами, валидацией, состоянием формы
@injectable
class DeliveryFormCubit extends Cubit<DeliveryFormState> {
  final OrderCalculationService _calculationService;
  final ValidateOrderDataUseCase _validateOrderDataUseCase;

  DeliveryFormCubit(
    this._calculationService,
    this._validateOrderDataUseCase,
  ) : super(DeliveryFormInitial());

  /// Инициализация формы
  /// Рассчитывает только итоговую стоимость - это единственная ответственность Cubit
  void initialize({
    required int subtotalPrice,
    required double deliveryPrice,
  }) {
    // Рассчитываем итоговую стоимость
    final totalOrderCost = _calculationService
        .calculateFinalTotalPrice(
          subtotalPrice: subtotalPrice.toDouble(),
          deliveryPrice: deliveryPrice,
        )
        .toInt();

    emit(DeliveryFormLoaded(
      totalOrderCost: totalOrderCost,
      paymentType: PaymentTypeDelivery.cash,
    ));
  }

  /// Изменение типа оплаты
  void changePaymentType(PaymentTypeDelivery paymentType) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    // Очищаем сдачу при смене с наличных на онлайн
    ChangeAmountResult? changeAmountResult = currentState.changeAmountResult;
    if (currentState.paymentType == PaymentTypeDelivery.cash && paymentType == PaymentTypeDelivery.online) {
      changeAmountResult = null;
    }

    emit(currentState.copyWith(
      paymentType: paymentType,
      changeAmountResult: changeAmountResult,
    ));
  }

  /// Установка результата выбора суммы сдачи
  void setChangeAmountResult(ChangeAmountResult? result) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    emit(currentState.copyWith(changeAmountResult: result));
  }

  /// Валидация и подготовка данных для подтверждения заказа
  /// Эмитит только состояние данных, без UI-команд
  void validateAndPrepareOrder({
    required int subtotalPrice,
    required double deliveryPrice,
    void Function()? onSuccess,
    void Function(String)? onError,
  }) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    final changeAmount = currentState.changeAmountResult?.toChangeAmount();

    final validationResult = _validateOrderDataUseCase(
      subtotalPrice: subtotalPrice,
      deliveryPrice: deliveryPrice,
      paymentType: currentState.paymentType,
      changeAmount: changeAmount,
    );

    if (!validationResult.isValid) {
      // Эмитим состояние с ошибкой валидации
      emit(currentState.copyWith(
        validationError: validationResult.errorMessage,
      ));
      onError?.call(validationResult.errorMessage ?? '');
      return;
    }

    // Эмитим состояние с увеличенным ID для подтверждения
    // Monotonic token гарантирует одноразовость события
    emit(currentState.copyWith(
      validationError: null,
      confirmationRequestId: currentState.confirmationRequestId + 1,
    ));
    onSuccess?.call();
  }

  /// Обновление итоговой стоимости (например, при изменении цены доставки)
  void updateTotalOrderCost({
    required int subtotalPrice,
    required double deliveryPrice,
  }) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    final totalOrderCost = _calculationService
        .calculateFinalTotalPrice(
          subtotalPrice: subtotalPrice.toDouble(),
          deliveryPrice: deliveryPrice,
        )
        .toInt();

    emit(currentState.copyWith(totalOrderCost: totalOrderCost));
  }
}
