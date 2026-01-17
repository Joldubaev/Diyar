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

  PickUpFormLoaded({
    this.selectedTime,
    required this.paymentType,
    required this.userName,
    required this.userPhone,
  });

  PickUpFormLoaded copyWith({
    String? selectedTime,
    String? paymentType,
    String? userName,
    String? userPhone,
  }) {
    return PickUpFormLoaded(
      selectedTime: selectedTime ?? this.selectedTime,
      paymentType: paymentType ?? this.paymentType,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
    );
  }
}

final class CreatePickUpOrderLoading extends PickUpState {}

final class CreatePickUpOrderLoaded extends PickUpState {
  final String message;
  final String paymentType;
  final int totalPrice;
  CreatePickUpOrderLoaded({
    required this.message,
    required this.paymentType,
    required this.totalPrice,
  });
}

final class CreatePickUpOrderError extends PickUpState {
  final String message;
  CreatePickUpOrderError(this.message);
}
