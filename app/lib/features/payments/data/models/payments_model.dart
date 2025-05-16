import 'package:diyar/features/payments/domain/domain.dart';

class PaymentsModel {
  final String? orderNumber;
  final String? user;
  final double? amount;
  final String? pinCode;
  final String? otp;

  PaymentsModel({
    this.orderNumber,
    this.user,
    this.amount,
    this.pinCode,
    this.otp,
  });

  factory PaymentsModel.fromEntity(PaymentsEntity entity) {
    return PaymentsModel(
      orderNumber: entity.orderNumber,
      user: entity.user,
      amount: entity.amount,
      pinCode: entity.pinCode,
      otp: entity.otp,
    );
  }

  

  factory PaymentsModel.fromJson(Map<String, dynamic> json) {
    return PaymentsModel(
      orderNumber: json['orderNumber'] as String?,
      user: json['user'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      pinCode: json['pinCode'] as String?,
      otp: json['otp'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'user': user,
      'amount': amount,
      'pinCode': pinCode,
      'otp': otp,
    };
  }

  PaymentsModel copyWith({String? orderNumber, String? user, double? amount, String? pinCode, String? otp}) {
    return PaymentsModel(
      orderNumber: orderNumber ?? this.orderNumber,
      user: user ?? this.user,
      amount: amount ?? this.amount,
      pinCode: pinCode ?? this.pinCode,
      otp: otp ?? this.otp,
    );
  }
}
