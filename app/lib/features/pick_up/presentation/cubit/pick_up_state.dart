part of 'pick_up_cubit.dart';

@immutable
sealed class PickUpState {}

final class PickUpInitial extends PickUpState {}

/// Состояние формы заказа самовывоза
final class PickUpFormLoaded extends PickUpState {
  final String? selectedTime;
  final String paymentType;
  final String userName;
  final String userPhone;
  final int totalPrice; // Полная сумма заказа (без вычета бонусов)
  final int totalOrderCost; // Сумма с учетом бонусов (для отображения в UI)
  final double? bonusAmount; // Сумма бонусов для списания

  PickUpFormLoaded({
    this.selectedTime,
    required this.paymentType,
    required this.userName,
    required this.userPhone,
    required this.totalPrice,
    required this.totalOrderCost,
    this.bonusAmount,
  });

  PickUpFormLoaded copyWith({
    String? selectedTime,
    String? paymentType,
    String? userName,
    String? userPhone,
    int? totalPrice,
    int? totalOrderCost,
    double? bonusAmount,
    bool clearBonusAmount = false,
  }) {
    return PickUpFormLoaded(
      selectedTime: selectedTime ?? this.selectedTime,
      paymentType: paymentType ?? this.paymentType,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      totalPrice: totalPrice ?? this.totalPrice,
      totalOrderCost: totalOrderCost ?? this.totalOrderCost,
      bonusAmount: clearBonusAmount ? null : (bonusAmount ?? this.bonusAmount),
    );
  }
}

final class CreatePickUpOrderLoading extends PickUpState {}

final class CreatePickUpOrderLoaded extends PickUpState {
  final String message;
  final String paymentType;
  final int totalPrice; // Полная сумма заказа (без вычета бонусов)
  final int totalOrderCost; // Сумма с учетом бонусов (для отображения в UI и оплаты)
  CreatePickUpOrderLoaded({
    required this.message,
    required this.paymentType,
    required this.totalPrice,
    required this.totalOrderCost,
  });
}

final class CreatePickUpOrderError extends PickUpState {
  final String message;
  CreatePickUpOrderError(this.message);
}
