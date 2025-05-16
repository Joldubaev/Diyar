import 'package:equatable/equatable.dart';

class PaymentsEntity extends Equatable {
  final String? orderNumber;
  final String? user;
  final double? amount;
  final String? pinCode;
  final String? otp;

  const PaymentsEntity({
    this.amount,
    this.orderNumber,
    this.otp,
    this.pinCode,
    this.user,
  });

  @override
  List<Object?> get props => [
    amount,
    otp,
    orderNumber,
    user,
    pinCode,
  ];
}
