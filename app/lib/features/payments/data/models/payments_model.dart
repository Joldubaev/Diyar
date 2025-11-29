import 'package:diyar/features/payments/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_model.freezed.dart';
part 'payments_model.g.dart';

@freezed
class PaymentsModel with _$PaymentsModel {
  const factory PaymentsModel({
    String? orderNumber,
    String? user,
    double? amount,
    String? pinCode,
    String? otp,
  }) = _PaymentsModel;

  factory PaymentsModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentsModelFromJson(json);

  factory PaymentsModel.fromEntity(PaymentsEntity entity) => PaymentsModel(
        orderNumber: entity.orderNumber,
        user: entity.user,
        amount: entity.amount,
        pinCode: entity.pinCode,
        otp: entity.otp,
      );
}

extension PaymentsModelX on PaymentsModel {
  PaymentsEntity toEntity() => PaymentsEntity(
        orderNumber: orderNumber,
        user: user,
        amount: amount,
        pinCode: pinCode,
        otp: otp,
      );
}
