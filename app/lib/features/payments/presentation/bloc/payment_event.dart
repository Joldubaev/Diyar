part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

//// Mega
class CheckPaymentMegaEvent extends PaymentEvent {
  final PaymentsEntity entity;

  const CheckPaymentMegaEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class InitiatePaymentMegaEvent extends PaymentEvent {
  final PaymentsEntity entity;

  const InitiatePaymentMegaEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class CheckPaymentStatusEvent extends PaymentEvent {
  final String orderNumber;

  const CheckPaymentStatusEvent(this.orderNumber);

  @override
  List<Object?> get props => [orderNumber];
}
//// qr code

class GenerateQrCodeEvent extends PaymentEvent {
  final int amount;
  const GenerateQrCodeEvent(this.amount);
  @override
  List<Object?> get props => [amount];
}

class CheckQrCodeStatusEvent extends PaymentEvent {
  final String transactionId;
  final String orderNumber;

  const CheckQrCodeStatusEvent(this.transactionId, this.orderNumber);

  @override
  List<Object?> get props => [transactionId, orderNumber];
}

class  ClearQrCodeEvent extends PaymentEvent {
  const ClearQrCodeEvent();
  @override
  List<Object?> get props => [];
}

/// mbank
class InitiateMbankEvent extends PaymentEvent {
  final PaymentsEntity entity;

  const InitiateMbankEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class ConfirmMbankEvent extends PaymentEvent {
  final PaymentsEntity entity;

  const ConfirmMbankEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class CheckMbankStatusEvent extends PaymentEvent {
  final String transactionId;

  const CheckMbankStatusEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}
