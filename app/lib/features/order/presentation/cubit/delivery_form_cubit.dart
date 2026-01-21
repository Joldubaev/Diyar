import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/core/components/components.dart';
import 'package:diyar/core/components/models/food_item_order_entity.dart';
import 'package:diyar/core/shared/shared.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/domain/usecases/order_usecase.dart';
import 'package:diyar/features/order/order.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'delivery_form_state.dart';

@injectable
class DeliveryFormCubit extends Cubit<DeliveryFormState> {
  final OrderCalculationService _calculationService;
  final CreateOrderUseCase _createOrderUseCase;

  DeliveryFormCubit(
    this._calculationService,
    this._createOrderUseCase,
  ) : super(DeliveryFormInitial());

  void initialize({
    required int subtotalPrice,
    required double deliveryPrice,
    String? rawAddress,
    String? initialUserName,
    String? initialUserPhone,
    String? initialHouseNumber,
  }) {
    final totalOrderCost = _calculationService
        .calculateFinalTotalPrice(
          subtotalPrice: subtotalPrice.toDouble(),
          deliveryPrice: deliveryPrice,
        )
        .toInt();

    emit(DeliveryFormLoaded(
      address: rawAddress ?? '',
      subtotalPrice: subtotalPrice,
      deliveryPrice: deliveryPrice,
      totalOrderCost: totalOrderCost,
      userName: initialUserName ?? '',
      userPhone: initialUserPhone ?? '+996',
      houseNumber: initialHouseNumber ?? '',
    ));
  }

  void toggleBonus(bool use) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    if (!use) {
      // Пересчитываем totalOrderCost без бонусов
      final totalOrderCost = _calculationService
          .calculateFinalTotalPrice(
            subtotalPrice: currentState.subtotalPrice.toDouble(),
            deliveryPrice: currentState.deliveryPrice,
          )
          .toInt();

      emit(currentState.copyWith(
        useBonus: false,
        totalOrderCost: totalOrderCost,
        clearBonusAmount: true,
      ));
    } else {
      emit(currentState.copyWith(useBonus: true));
    }
  }

  // --- Логика Бонусов ---
  void setBonusAmount(double? amount, double userBalance) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    log('[DeliveryFormCubit] setBonusAmount: Начало установки суммы бонусов');
    log('[DeliveryFormCubit] setBonusAmount: amount=$amount, userBalance=$userBalance');
    log('[DeliveryFormCubit] setBonusAmount: subtotalPrice=${currentState.subtotalPrice}, deliveryPrice=${currentState.deliveryPrice}');

    // Если amount null или 0, просто обнуляем бонусы и пересчитываем totalOrderCost
    if (amount == null || amount == 0) {
      log('[DeliveryFormCubit] setBonusAmount: amount null или 0, обнуляем бонусы');
      final totalOrderCost = _calculationService
          .calculateFinalTotalPrice(
            subtotalPrice: currentState.subtotalPrice.toDouble(),
            deliveryPrice: currentState.deliveryPrice,
          )
          .toInt();

      log('[DeliveryFormCubit] setBonusAmount: totalOrderCost без бонусов=$totalOrderCost');
      emit(currentState.copyWith(
        totalOrderCost: totalOrderCost,
        clearBonusAmount: true,
        clearValidationError: true,
      ));
      return;
    }

    // Проверка: бонусы не могут превышать баланс пользователя
    if (amount > userBalance) {
      log('[DeliveryFormCubit] setBonusAmount: ОШИБКА - Недостаточно бонусов (amount=$amount > userBalance=$userBalance)');
      emit(currentState.copyWith(validationError: 'Недостаточно бонусов'));
      return;
    }

    // Проверка: бонусы не могут превышать полную стоимость заказа
    final baseTotalOrderCost = currentState.subtotalPrice + currentState.deliveryPrice.toInt();
    log('[DeliveryFormCubit] setBonusAmount: baseTotalOrderCost=$baseTotalOrderCost (subtotalPrice=${currentState.subtotalPrice} + deliveryPrice=${currentState.deliveryPrice.toInt()})');
    log('[DeliveryFormCubit] setBonusAmount: Сравнение: amount=$amount > baseTotalOrderCost=$baseTotalOrderCost = ${amount > baseTotalOrderCost}');

    if (amount > baseTotalOrderCost) {
      log('[DeliveryFormCubit] setBonusAmount: ОШИБКА - Сумма бонусов превышает стоимость заказа');
      emit(currentState.copyWith(validationError: 'Сумма бонусов не может превышать стоимость заказа'));
      return;
    }

    // Пересчитываем totalOrderCost с учетом бонусов
    final totalOrderCost = (baseTotalOrderCost - amount).toInt();
    log('[DeliveryFormCubit] setBonusAmount: totalOrderCost с учетом бонусов=$totalOrderCost (baseTotalOrderCost=$baseTotalOrderCost - amount=$amount)');

    // Сохраняем сумму бонусов и обновляем totalOrderCost
    emit(currentState.copyWith(
      bonusAmount: amount,
      totalOrderCost: totalOrderCost,
      clearValidationError: true,
    ));
    log('[DeliveryFormCubit] setBonusAmount: Бонусы успешно установлены: bonusAmount=$amount, totalOrderCost=$totalOrderCost');
  }

  // --- ФИНАЛЬНЫЙ ШАГ: Создание заказа ---
  Future<void> submitOrder(CreateOrderEntity orderEntity) async {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    emit(currentState.copyWith(
      isSubmitting: true,
      clearValidationError: true,
      clearSuccessMessage: true,
    ));

    final result = await _createOrderUseCase(orderEntity);

    // Получаем актуальное состояние после async операции
    final updatedState = state;
    if (updatedState is! DeliveryFormLoaded) return;

    result.fold(
      (failure) => emit(updatedState.copyWith(
        isSubmitting: false,
        validationError: failure.message,
        successMessage: null,
      )),
      (message) => emit(updatedState.copyWith(
        isSubmitting: false,
        successMessage: message,
        validationError: null,
      )),
    );
  }

  /// Обновление полей формы
  void updateField({
    String? userName,
    String? userPhone,
    String? address,
    String? houseNumber,
    String? entrance,
    String? floor,
    String? apartment,
    String? intercom,
    String? comment,
  }) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    emit(currentState.copyWith(
      userName: userName,
      userPhone: userPhone,
      address: address,
      houseNumber: houseNumber,
      entrance: entrance,
      floor: floor,
      apartment: apartment,
      intercom: intercom,
      comment: comment,
    ));
  }

  /// Установка суммы сдачи
  void setChangeAmount(int? amount) {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    emit(currentState.copyWith(changeAmount: amount));
  }

  /// Подтверждение заказа - собирает CreateOrderEntity из данных state и создает заказ
  Future<void> confirmOrder({
    required List<CartItemEntity> cart,
    required String? region,
  }) async {
    final currentState = state;
    if (currentState is! DeliveryFormLoaded) return;

    // Дополнительная валидация бонусов перед созданием заказа
    if (currentState.bonusAmount != null && currentState.bonusAmount! > 0) {
      final baseTotalOrderCost = currentState.subtotalPrice + currentState.deliveryPrice.toInt();
      if (currentState.bonusAmount! > baseTotalOrderCost) {
        emit(currentState.copyWith(
          validationError: 'Сумма бонусов не может превышать стоимость заказа',
        ));
        return;
      }
    }

    // Собираем AddressEntity из state
    final addressData = AddressEntity(
      address: currentState.address,
      houseNumber: currentState.houseNumber,
      comment: currentState.comment.isEmpty ? null : currentState.comment,
      entrance: currentState.entrance.isEmpty ? null : currentState.entrance,
      floor: currentState.floor.isEmpty ? null : currentState.floor,
      intercom: currentState.intercom.isEmpty ? null : currentState.intercom,
      kvOffice: currentState.apartment.isEmpty ? null : currentState.apartment,
      region: region,
    );

    // Собираем ContactInfoEntity из state
    final contactInfo = ContactInfoEntity(
      userName: currentState.userName.trim(),
      userPhone: currentState.userPhone.trim(),
    );

    // Вычисляем dishesCount из cart
    final dishesCount = cart.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

    // Преобразуем cart в список FoodItemOrderEntity
    final foods = cart
        .map((e) => FoodItemOrderEntity(
              dishId: '${e.food?.id}',
              name: e.food?.name ?? '',
              price: e.food?.price ?? 0,
              quantity: e.quantity ?? 1,
            ))
        .toList();

    // Получаем sdacha из state
    final sdacha = currentState.paymentType == PaymentTypeDelivery.cash ? currentState.changeAmount : null;

    // Вычисляем полную стоимость заказа БЕЗ вычета бонусов (для отправки на сервер)
    final fullOrderPrice = currentState.subtotalPrice + currentState.deliveryPrice.toInt();

    log('[DeliveryFormCubit] confirmOrder: Подготовка данных для отправки на бэкенд');
    log('[DeliveryFormCubit] confirmOrder: subtotalPrice=${currentState.subtotalPrice}');
    log('[DeliveryFormCubit] confirmOrder: deliveryPrice=${currentState.deliveryPrice.toInt()}');
    log('[DeliveryFormCubit] confirmOrder: fullOrderPrice (для бэкенда)=$fullOrderPrice');
    log('[DeliveryFormCubit] confirmOrder: bonusAmount (amountToReduce)=${currentState.bonusAmount}');
    log('[DeliveryFormCubit] confirmOrder: totalOrderCost (для UI, с учетом бонусов)=${currentState.totalOrderCost}');
    log('[DeliveryFormCubit] confirmOrder: Бэкенд сам вычтет бонусы: finalPrice = $fullOrderPrice - ${currentState.bonusAmount ?? 0} = ${fullOrderPrice - (currentState.bonusAmount ?? 0)}');

    // Создаем CreateOrderEntity
    // Отправляем полную сумму без вычета бонусов, бонусы передаем отдельно в amountToReduce
    // Бэкенд сам вычтет бонусы из полной суммы
    final orderEntity = CreateOrderEntity(
      addressData: addressData,
      contactInfo: contactInfo,
      price: fullOrderPrice, // Полная сумма без вычета бонусов - бэкенд сам вычтет бонусы
      deliveryPrice: currentState.deliveryPrice.toInt(),
      paymentMethod: currentState.paymentType.name,
      dishesCount: dishesCount,
      sdacha: sdacha,
      amountToReduce:
          currentState.bonusAmount != null && currentState.bonusAmount! > 0 ? currentState.bonusAmount : null,
      foods: foods,
    );

    log('[DeliveryFormCubit] confirmOrder: Отправка заказа на бэкенд: price=$fullOrderPrice, amountToReduce=${orderEntity.amountToReduce}');

    // Вызываем submitOrder
    await submitOrder(orderEntity);
  }
}
