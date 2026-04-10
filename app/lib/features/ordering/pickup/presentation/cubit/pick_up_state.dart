part of 'pick_up_cubit.dart';

@immutable
sealed class PickUpState extends Equatable {
  const PickUpState();

  @override
  List<Object?> get props => [];
}

final class PickUpInitial extends PickUpState {
  const PickUpInitial();
}

/// Состояние формы заказа самовывоза
final class PickUpFormLoaded extends PickUpState {
  final String? selectedTime;
  final PaymentTypeDelivery paymentType;
  final String userName;
  final String userPhone;
  final int totalPrice; // Полная сумма заказа (без вычета бонусов)
  final int totalOrderCost; // Сумма с учетом бонусов (для отображения в UI)
  final double? bonusAmount; // Сумма бонусов для списания
  final String? bonusError;

  const PickUpFormLoaded({
    this.selectedTime,
    required this.paymentType,
    required this.userName,
    required this.userPhone,
    required this.totalPrice,
    required this.totalOrderCost,
    this.bonusAmount,
    this.bonusError,
  });

  @override
  List<Object?> get props => [
        selectedTime,
        paymentType,
        userName,
        userPhone,
        totalPrice,
        totalOrderCost,
        bonusAmount,
        bonusError,
      ];

  PickUpFormLoaded copyWith({
    String? selectedTime,
    PaymentTypeDelivery? paymentType,
    String? userName,
    String? userPhone,
    int? totalPrice,
    int? totalOrderCost,
    double? bonusAmount,
    String? bonusError,
    bool clearBonusAmount = false,
    bool clearBonusError = false,
  }) {
    return PickUpFormLoaded(
      selectedTime: selectedTime ?? this.selectedTime,
      paymentType: paymentType ?? this.paymentType,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      totalPrice: totalPrice ?? this.totalPrice,
      totalOrderCost: totalOrderCost ?? this.totalOrderCost,
      bonusAmount: clearBonusAmount ? null : (bonusAmount ?? this.bonusAmount),
      bonusError: clearBonusError ? null : (bonusError ?? this.bonusError),
    );
  }
}

/// Базовое состояние для процессов создания заказа (содержит суммы).
abstract class PickUpOrderState extends PickUpState {
  final int totalPrice;
  final int totalOrderCost;

  const PickUpOrderState({
    required this.totalPrice,
    required this.totalOrderCost,
  });

  @override
  List<Object?> get props => [...super.props, totalPrice, totalOrderCost];
}

final class CreatePickUpOrderLoading extends PickUpOrderState {
  const CreatePickUpOrderLoading({
    required super.totalPrice,
    required super.totalOrderCost,
  });
}

final class CreatePickUpOrderLoaded extends PickUpOrderState {
  final String message;
  final String paymentType;
  const CreatePickUpOrderLoaded({
    required this.message,
    required this.paymentType,
    required super.totalPrice,
    required super.totalOrderCost,
  });

  @override
  List<Object?> get props => [message, paymentType, totalPrice, totalOrderCost];
}

final class CreatePickUpOrderError extends PickUpState {
  final String message;
  const CreatePickUpOrderError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Состояние ошибки при работе с бонусами
// Отдельного состояния ошибки бонусов больше нет — ошибка хранится в PickUpFormLoaded.bonusError.
