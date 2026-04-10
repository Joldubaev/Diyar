import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/ordering/delivery/presentation/enum/delivery_enum.dart';
import 'package:diyar/features/ordering/pickup/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'pick_up_state.dart';

/// Cubit для управления состоянием формы PickUp заказа
@injectable
class PickUpCubit extends Cubit<PickUpState> {
  final PickUpRepository _pickUpRepository;
  final CreatePickupOrderFromCartUseCase _createPickupOrderFromCartUseCase;
  final CalculateMinimumTimeUseCase _calculateMinimumTimeUseCase;
  final ValidateBonusUseCase _validateBonusUseCase;

  PickUpCubit(
    this._pickUpRepository,
    this._createPickupOrderFromCartUseCase,
    this._calculateMinimumTimeUseCase,
    this._validateBonusUseCase,
  ) : super(PickUpInitial());

  /// Инициализация формы с данными пользователя
  void initializeForm({
    required PaymentTypeDelivery paymentType,
    required String userName,
    required String userPhone,
    required int totalPrice,
  }) {
    emit(
      PickUpFormLoaded(
        userName: userName,
        userPhone: userPhone,
        paymentType: paymentType,
        totalPrice: totalPrice,
        totalOrderCost: totalPrice,
      ),
    );
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
    _validateAndApplyBonus(currentState, amount, userBalance);
  }

  /// Изменение типа оплаты
  void changePaymentType(PaymentTypeDelivery paymentType) {
    final currentState = state;
    if (currentState is PickUpFormLoaded) {
      emit(currentState.copyWith(paymentType: paymentType));
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

  /// Парсинг строки времени в DateTime
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

  /// Создание заказа из корзины и данных формы
  Future<void> createPickupOrder({
    required List<CartItemEntity> cart,
    required String userName,
    required String phone,
    required String time,
    required String comment,
    required String paymentMethod,
  }) async {
    final currentState = state;
    if (currentState is! PickUpFormLoaded) return;

    // Всегда вычисляем количество блюд из корзины
    final calculatedDishesCount =
        cart.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

    // Создаем заказ через use case
    final order = _createPickupOrderFromCartUseCase(
      cartItems: cart,
      userName: userName,
      userPhone: phone,
      prepareFor: time,
      comment: comment.isEmpty ? null : comment,
      paymentMethod: paymentMethod,
      totalPrice: currentState.totalPrice,
      dishCount: calculatedDishesCount,
      bonusAmount: currentState.bonusAmount,
    );

    // Переходим в состояние загрузки и отправляем заказ
    emit(
      CreatePickUpOrderLoading(
        totalPrice: currentState.totalPrice,
        totalOrderCost: currentState.totalOrderCost,
      ),
    );

    await _submitOrder(order, paymentMethod);
  }

  /// Валидация и применение бонусов к текущему состоянию формы.
  void _validateAndApplyBonus(
    PickUpFormLoaded currentState,
    double? amount,
    double userBalance,
  ) {
    // Валидация бонусов через UseCase
    final validationResult = _validateBonusUseCase.validate(
      amount: amount,
      userBalance: userBalance,
      orderTotal: currentState.totalPrice,
    );

    if (!_validateBonusUseCase.isValid(validationResult)) {
      final errorMessage = _validateBonusUseCase.getErrorMessage(
        validationResult,
        userBalance: userBalance,
        orderTotal: currentState.totalPrice,
      );
      // Сохраняем ошибку как часть состояния формы
      emit(
        currentState.copyWith(
          bonusError: errorMessage,
          clearBonusError: false,
        ),
      );
      return;
    }

    // Если бонусы null или 0 - обнуляем и очищаем ошибку
    if (amount == null || amount == 0) {
      emit(
        currentState.copyWith(
          totalOrderCost: currentState.totalPrice,
          clearBonusAmount: true,
          clearBonusError: true,
        ),
      );
      return;
    }

    // Пересчитываем totalOrderCost с учетом бонусов и очищаем ошибку
    final totalOrderCost = (currentState.totalPrice - amount).toInt();

    emit(
      currentState.copyWith(
        bonusAmount: amount,
        totalOrderCost: totalOrderCost,
        clearBonusError: true,
      ),
    );
  }

  /// Отправка заказа в репозиторий
  Future<void> _submitOrder(
    PickupOrderEntity order,
    String paymentType,
  ) async {
    try {
      final result = await _pickUpRepository.getPickupOrder(order);
      result.fold(
        (failure) => emit(CreatePickUpOrderError(failure.message)),
        (entity) {
          final loadingState = state;
          if (loadingState is CreatePickUpOrderLoading) {
            emit(
              CreatePickUpOrderLoaded(
                message: entity,
                paymentType: paymentType,
                totalPrice: loadingState.totalPrice,
                totalOrderCost: loadingState.totalOrderCost,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }
}
