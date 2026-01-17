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
  }) {
    emit(PickUpFormLoaded(
      userName: userName,
      userPhone: userPhone,
      paymentType: PaymentTypeDelivery.cash.name,
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
    required int totalPrice,
    required int? dishCount,
    double? bonusAmount,
  }) async {
    emit(CreatePickUpOrderLoading());

    try {
      // Вычисляем dishesCount из cart
      final calculatedDishesCount = dishCount ?? cart.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0));

      // Используем usecase для создания заказа (с поддержкой бонусов)
      final order = _createPickupOrderFromCartUseCase(
        cartItems: cart,
        userName: userName.trim(),
        userPhone: phone.trim(),
        prepareFor: time.trim(),
        comment: comment.trim().isEmpty ? null : comment.trim(),
        paymentMethod: paymentMethod,
        totalPrice: totalPrice,
        dishCount: calculatedDishesCount,
        bonusAmount: bonusAmount,
      );

      await submitPickupOrderEntity(order, paymentMethod, totalPrice);
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
        (entity) => emit(CreatePickUpOrderLoaded(
          message: entity,
          paymentType: paymentType,
          totalPrice: totalPrice,
        )),
      );
    } catch (e) {
      emit(CreatePickUpOrderError(e.toString()));
    }
  }
}
