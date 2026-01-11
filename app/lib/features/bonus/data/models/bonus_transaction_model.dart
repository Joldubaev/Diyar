import 'package:diyar/features/bonus/domain/entities/bonus_transaction_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bonus_transaction_model.freezed.dart';

@freezed
class BonusTransactionModel with _$BonusTransactionModel {
  const factory BonusTransactionModel({
    required String id,
    required String userId,
    required String userName,
    required String phone,
    required String type,
    required double amount,
    required double balanceAfter,
    String? description,
    required DateTime createdAt,
  }) = _BonusTransactionModel;

  factory BonusTransactionModel.fromJson(Map<String, dynamic> json) {
    return BonusTransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: _dateTimeFromJson(json['createdAt']),
    );
  }
}

DateTime _dateTimeFromJson(dynamic json) {
  if (json is String) {
    return DateTime.parse(json);
  }
  if (json is int) {
    return DateTime.fromMillisecondsSinceEpoch(json);
  }
  throw FormatException('Invalid DateTime format: $json');
}

extension BonusTransactionModelX on BonusTransactionModel {
  BonusTransactionEntity toEntity() => BonusTransactionEntity(
        id: id,
        userId: userId,
        userName: userName,
        phone: phone,
        type: type,
        amount: amount,
        balanceAfter: balanceAfter,
        description: description,
        createdAt: createdAt,
      );
}
