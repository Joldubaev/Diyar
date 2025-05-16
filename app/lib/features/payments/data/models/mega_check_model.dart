import 'package:diyar/features/payments/domain/domain.dart';

class MegaCheckModel {
  final int? commission;
  final int? amount;

  MegaCheckModel({
    this.commission,
    this.amount,
  });

  MegaCheckModel copyWith({
    int? commission,
    int? amount,
  }) =>
      MegaCheckModel(
        commission: commission ?? this.commission,
        amount: amount ?? this.amount,
      );

  Map<String, dynamic> toJson() {
    return {
      'commission': commission,
      'amount': amount,
    };
  }

  factory MegaCheckModel.fromJson(Map<String, dynamic> map) {
    return MegaCheckModel(
      commission: map['commission']?.toInt(),
      amount: map['amount']?.toInt(),
    );
  }

  factory MegaCheckModel.fromEntity(MegaCheckEntity entity) {
    return MegaCheckModel(
      commission: entity.commission,
      amount: entity.amount,
    );
  }
  MegaCheckEntity toEntity() {
    return MegaCheckEntity(
      commission: commission,
      amount: amount,
    );
  }
}
