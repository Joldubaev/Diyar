part of 'delivery_form_cubit.dart';

sealed class DeliveryFormState extends Equatable {
  const DeliveryFormState();

  @override
  List<Object?> get props => [];
}

final class DeliveryFormInitial extends DeliveryFormState {}
final class DeliveryFormLoaded extends DeliveryFormState {
  // Данные для заказа
  final String address;
  final int subtotalPrice;
  final double deliveryPrice;
  final int totalOrderCost;
  
  // Поля формы (контактные данные)
  final String userName;
  final String userPhone;
  
  // Поля формы (адрес)
  final String houseNumber;
  final String entrance;
  final String floor;
  final String apartment;
  final String intercom;
  final String comment;
  
  // Сдача
  final int? changeAmount;
  
  // Поля формы (бонусы и оплата)
  final bool useBonus;
  final double? bonusAmount;
  final PaymentTypeDelivery paymentType;
  
  // Статусы процесса (вместо кучи мелких стейтов)
  final bool isSubmitting; // Заменяет CreateOrderLoading
  final String? validationError;
  final String? successMessage; // Если заказ создан
  final int confirmationRequestId;

  const DeliveryFormLoaded({
    required this.address,
    required this.subtotalPrice,
    required this.deliveryPrice,
    required this.totalOrderCost,
    this.userName = '',
    this.userPhone = '+996',
    this.houseNumber = '',
    this.entrance = '',
    this.floor = '',
    this.apartment = '',
    this.intercom = '',
    this.comment = '',
    this.changeAmount,
    this.useBonus = false,
    this.bonusAmount,
    this.paymentType = PaymentTypeDelivery.cash,
    this.validationError,
    this.successMessage,
    this.isSubmitting = false,
    this.confirmationRequestId = 0,
  });


  DeliveryFormLoaded copyWith({
    String? address,
    int? subtotalPrice,
    double? deliveryPrice,
    int? totalOrderCost,
    String? userName,
    String? userPhone,
    String? houseNumber,
    String? entrance,
    String? floor,
    String? apartment,
    String? intercom,
    String? comment,
    int? changeAmount,
    bool? useBonus,
    double? bonusAmount,
    PaymentTypeDelivery? paymentType,
    String? validationError,
    String? successMessage,
    bool? isSubmitting,
    int? confirmationRequestId,
    bool clearBonusAmount = false,
    bool clearChangeAmount = false,
    bool clearValidationError = false,
    bool clearSuccessMessage = false,
  }) {
    return DeliveryFormLoaded(
      address: address ?? this.address,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      totalOrderCost: totalOrderCost ?? this.totalOrderCost,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      houseNumber: houseNumber ?? this.houseNumber,
      entrance: entrance ?? this.entrance,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      intercom: intercom ?? this.intercom,
      comment: comment ?? this.comment,
      changeAmount: clearChangeAmount ? null : (changeAmount ?? this.changeAmount),
      useBonus: useBonus ?? this.useBonus,
      bonusAmount: clearBonusAmount ? null : (bonusAmount ?? this.bonusAmount),
      paymentType: paymentType ?? this.paymentType,
      validationError: clearValidationError ? null : (validationError ?? this.validationError),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      confirmationRequestId: confirmationRequestId ?? this.confirmationRequestId,
    );
  }

  @override
  List<Object?> get props => [
        address,
        subtotalPrice,
        deliveryPrice,
        totalOrderCost,
        userName,
        userPhone,
        houseNumber,
        entrance,
        floor,
        apartment,
        intercom,
        comment,
        changeAmount,
        useBonus,
        bonusAmount,
        paymentType,
        isSubmitting,
        validationError,
        successMessage,
        confirmationRequestId,
      ];
}