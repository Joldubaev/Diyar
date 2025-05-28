part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Mega

class PaymentCheckSuccess extends PaymentState {
  final String checkResult;

  const PaymentCheckSuccess(this.checkResult);

  @override
  List<Object?> get props => [checkResult];
}

class PaymentInitiateSuccess extends PaymentState {}

class PaymentStatusSuccess extends PaymentState {
  final String status;

  const PaymentStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

/// QR Code

class PaymentQrCodeSuccess extends PaymentState {
  final QrCodeEntity qrCode;

  const PaymentQrCodeSuccess(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

class PaymentQrCodeError extends PaymentState {
  final String message;

  const PaymentQrCodeError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentQrCodeLoading extends PaymentState {}

class PaymentQrCodeStatusSuccess extends PaymentState {
  final QrPaymentStatusEntity status;

  const PaymentQrCodeStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

/// Mbank
class PaymentMbankLoading extends PaymentState {}

class PaymentMbankSuccess extends PaymentState {
  final MbankEntity? mbank;

  const PaymentMbankSuccess(this.mbank);

  @override
  List<Object?> get props => [mbank];
}

class PaymentMbankStatusSuccess extends PaymentState {
  final PaymentStatusEnum statusEnum;
  final String message;
  // final double amount; // если нужно

  const PaymentMbankStatusSuccess({required this.statusEnum, required this.message});

  @override
  List<Object?> get props => [statusEnum, message];
}

class PaymentMbankError extends PaymentState {
  final String message;
  final PaymentStatusEnum status;

  const PaymentMbankError(this.message, {this.status = PaymentStatusEnum.unknown});

  @override
  List<Object?> get props => [message, status];
}
