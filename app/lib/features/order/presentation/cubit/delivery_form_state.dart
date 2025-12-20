part of 'delivery_form_cubit.dart';

sealed class DeliveryFormState extends Equatable {
  const DeliveryFormState();

  @override
  List<Object?> get props => [];
}

final class DeliveryFormInitial extends DeliveryFormState {}

/// Состояние загруженной формы
/// Содержит только актуальное состояние формы
final class DeliveryFormLoaded extends DeliveryFormState {
  final int totalOrderCost;
  final PaymentTypeDelivery paymentType;
  final ChangeAmountResult? changeAmountResult;
  final String? validationError;

  // Monotonic token для одноразовых событий подтверждения заказа
  // Увеличивается при каждой успешной валидации, не требует ручного сброса
  final int confirmationRequestId;

  const DeliveryFormLoaded({
    required this.totalOrderCost,
    required this.paymentType,
    this.changeAmountResult,
    this.validationError,
    this.confirmationRequestId = 0,
  });

  DeliveryFormLoaded copyWith({
    int? totalOrderCost,
    PaymentTypeDelivery? paymentType,
    ChangeAmountResult? changeAmountResult,
    String? validationError,
    int? confirmationRequestId,
    bool clearValidationError = false,
  }) {
    return DeliveryFormLoaded(
      totalOrderCost: totalOrderCost ?? this.totalOrderCost,
      paymentType: paymentType ?? this.paymentType,
      changeAmountResult: changeAmountResult ?? this.changeAmountResult,
      validationError: clearValidationError ? null : (validationError ?? this.validationError),
      confirmationRequestId: confirmationRequestId ?? this.confirmationRequestId,
    );
  }

  @override
  List<Object?> get props => [
        totalOrderCost,
        paymentType,
        changeAmountResult,
        validationError,
        confirmationRequestId,
      ];
}
