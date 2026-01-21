import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/pick_up/domain/domain.dart';
import 'package:injectable/injectable.dart';

part 'pick_up_state.dart';

@injectable
class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepositories _pickUpRepository;
  final CreatePickupOrderFromCartUseCase _createPickupOrderFromCartUseCase;
  final CalculateMinimumTimeUseCase _calculateMinimumTimeUseCase;

  PickUpCubit(
    this._pickUpRepository,
    this._createPickupOrderFromCartUseCase,
    this._calculateMinimumTimeUseCase,
  ) : super(PickUpInitial());

  /// Инициализация формы с данными пользователя
  void initializeForm({
    required String userName,
    required String userPhone,
    required int totalPrice,
  }) {
    emit(PickUpFormLoaded(
      userName: userName,
      userPhone: userPhone,
      paymentType: PaymentTypeDelivery.cash.name,
      totalPrice: totalPrice,
      totalOrderCost: totalPrice, // Изначально totalOrderCost = totalPrice (без бонусов)
    ));
  }

  /// Обновление данных формы
  void updateFormData({
    String? userName,
    String? userPhone,
  }) {
    final currentState = state;
    if (currentState is PickUpFormLoaded) {
      emit(currentState.copyWith(
        userName: userName,
        userPhone: userPhone,
      ));
    }
  }

  /// Установка суммы бонусов и пересчет totalOrderCost
  void setBonusAmount(double? amount, double userBalance) {
    final currentState = state;
    if (currentState is! PickUpFormLoaded) return;

    log('[PickUpCubit] setBonusAmount: Начало установки суммы бонусов');
    log('[PickUpCubit] setBonusAmount: amount=$amount, userBalance=$userBalance');
    log('[PickUpCubit] setBonusAmount: totalPrice=${currentState.totalPrice}');

    // Если amount null или 0, просто обнуляем бонусы и пересчитываем totalOrderCost
    if (amount == null || amount == 0) {
      log('[PickUpCubit] setBonusAmount: amount null или 0, обнуляем бонусы');
      emit(currentState.copyWith(
        totalOrderCost: currentState.totalPrice,
        clearBonusAmount: true,
      ));
      log('[PickUpCubit] setBonusAmount: totalOrderCost без бонусов=${currentState.totalPrice}');
      return;
    }

    // Проверка: бонусы не могут превышать баланс пользователя
    if (amount > userBalance) {
      log('[PickUpCubit] setBonusAmount: ОШИБКА - Недостаточно бонусов (amount=$amount > userBalance=$userBalance)');
      // Можно добавить обработку ошибки, если нужно
      return;
    }

    // Проверка: бонусы не могут превышать полную стоимость заказа
    if (amount > currentState.totalPrice) {
      log('[PickUpCubit] setBonusAmount: ОШИБКА - Сумма бонусов превышает стоимость заказа (amount=$amount > totalPrice=${currentState.totalPrice})');
      // Можно добавить обработку ошибки, если нужно
      return;
    }

    // Пересчитываем totalOrderCost с учетом бонусов
    final totalOrderCost = (currentState.totalPrice - amount).toInt();
    log('[PickUpCubit] setBonusAmount: totalOrderCost с учетом бонусов=$totalOrderCost (totalPrice=${currentState.totalPrice} - amount=$amount)');

    // Сохраняем сумму бонусов и обновляем totalOrderCost
    emit(currentState.copyWith(
      bonusAmount: amount,
      totalOrderCost: totalOrderCost,
    ));
    log('[PickUpCubit] setBonusAmount: Бонусы успешно установлены: bonusAmount=$amount, totalOrderCost=$totalOrderCost');
  }

  /// Изменение типа оплаты
  void changePaymentType(PaymentTypeDelivery paymentType) {
    final currentState = state;
    if (currentState is PickUpFormLoaded) {
      emit(currentState.copyWith(paymentType: paymentType.name));
    }
  }

  /// Установка выбранного времени
  void setSelectedTime(String time) {
    final currentState = state;
    if (currentState is PickUpFormLoaded) {
      emit(currentState.copyWith(selectedTime: time));
    }
  }

  /// Получение минимального времени для выбора
  DateTime getMinimumTime() {
    return _calculateMinimumTimeUseCase.getMinimumTime();
  }

  /// Форматирование времени в строку
  String formatTime(DateTime dateTime) {
    return _calculateMinimumTimeUseCase.formatTime(dateTime);
  }

  /// Парсинг строки времени
  DateTime? parseTimeString(String timeString) {
    return _calculateMinimumTimeUseCase.parseTimeString(
      timeString,
      DateTime.now(),
    );
  }

  /// Валидация и установка времени
  void validateAndSetTime(DateTime selectedTime) {
    final minimumTime = getMinimumTime();
    final validatedTime = _calculateMinimumTimeUseCase.validateSelectedTime(
      selectedTime,
      minimumTime,
    );
    setSelectedTime(formatTime(validatedTime));
  }

  /// Создание заказа из корзины и данных формы (с поддержкой бонусов)
  Future<void> createPickupOrder({
    required List<CartItemEntity> cart,
    required String userName,
    required String phone,
    required String time,
    required String comment,
    required String paymentMethod,
    required int? dishCount,
  }) async {
    final currentState = state;
    if (currentState is! PickUpFormLoaded) return;

    emit(CreatePickUpOrderLoading());

    try {
      // Вычисляем dishesCount из cart
      final calculatedDishesCount = dishCount ?? cart.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

      // Получаем полную сумму заказа БЕЗ вычета бонусов (для отправки на сервер)
      final fullOrderPrice = currentState.totalPrice;

      log('[PickUpCubit] createPickupOrder: Подготовка данных для отправки на бэкенд');
      log('[PickUpCubit] createPickupOrder: totalPrice (полная сумма БЕЗ бонусов, для бэкенда)=$fullOrderPrice');
      log('[PickUpCubit] createPickupOrder: bonusAmount (amountToReduce)=${currentState.bonusAmount}');
      log('[PickUpCubit] createPickupOrder: totalOrderCost (для UI, С УЧЕТОМ бонусов)=${currentState.totalOrderCost}');
      log('[PickUpCubit] createPickupOrder: Бэкенд сам вычтет бонусы: finalPrice = $fullOrderPrice - ${currentState.bonusAmount ?? 0} = ${fullOrderPrice - (currentState.bonusAmount ?? 0)}');

      // Используем usecase для создания заказа (с поддержкой бонусов)
      // Отправляем полную сумму без вычета бонусов, бонусы передаем отдельно в amountToReduce
      // Бэкенд сам вычтет бонусы из полной суммы
      final order = _createPickupOrderFromCartUseCase(
        cartItems: cart,
        userName: userName.trim(),
        userPhone: phone.trim(),
        prepareFor: time.trim(),
        comment: comment.trim().isEmpty ? null : comment.trim(),
        paymentMethod: paymentMethod,
        totalPrice: fullOrderPrice, // Полная сумма без вычета бонусов - бэкенд сам вычтет бонусы
        dishCount: calculatedDishesCount,
        bonusAmount: currentState.bonusAmount, // Бонусы передаем отдельно
      );

      log('[PickUpCubit] createPickupOrder: Отправка заказа на бэкенд: totalPrice=$fullOrderPrice, bonusAmount=${currentState.bonusAmount}');

      await submitPickupOrderEntity(order, paymentMethod, fullOrderPrice);
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }

  /// Отправка заказа (приватный метод)
  Future<void> submitPickupOrderEntity(
    PickupOrderEntity order,
    String paymentType,
    int totalPrice,
  ) async {
    emit(CreatePickUpOrderLoading());
    try {
      final result = await _pickUpRepository.getPickupOrder(order);
      result.fold(
        (failure) => emit(CreatePickUpOrderError(failure.message)),
        (entity) {
          final currentState = state;
          if (currentState is PickUpFormLoaded) {
            emit(CreatePickUpOrderLoaded(
              message: entity,
              paymentType: paymentType,
              totalPrice: totalPrice,
              totalOrderCost: currentState.totalOrderCost,
            ));
          } else {
            // Fallback, если state не PickUpFormLoaded
            emit(CreatePickUpOrderLoaded(
              message: entity,
              paymentType: paymentType,
              totalPrice: totalPrice,
              totalOrderCost: totalPrice,
            ));
          }
        },
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }
}
