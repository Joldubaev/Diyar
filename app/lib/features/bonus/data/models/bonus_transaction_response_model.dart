import 'package:diyar/features/bonus/domain/entities/bonus_transaction_response_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'bonus_transaction_model.dart';

part 'bonus_transaction_response_model.freezed.dart';
// part 'bonus_transaction_response_model.g.dart';

@freezed
class BonusTransactionResponseModel with _$BonusTransactionResponseModel {
  const factory BonusTransactionResponseModel({
    required List<BonusTransactionModel> transactions,
    required int totalItems,
    required int totalPages,
  }) = _BonusTransactionResponseModel;

  factory BonusTransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return BonusTransactionResponseModel(
      transactions: (json['transactions'] as List<dynamic>)
          .map((x) => BonusTransactionModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

extension BonusTransactionResponseModelX on BonusTransactionResponseModel {
  BonusTransactionResponseEntity toEntity() => BonusTransactionResponseEntity(
        transactions: transactions.map((t) => t.toEntity()).toList(),
        totalItems: totalItems,
        totalPages: totalPages,
      );
}
