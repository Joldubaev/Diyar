import 'package:freezed_annotation/freezed_annotation.dart';
import 'bonus_transaction_entity.dart';

part 'bonus_transaction_response_entity.freezed.dart';

@freezed
class BonusTransactionResponseEntity with _$BonusTransactionResponseEntity {
  const factory BonusTransactionResponseEntity({
    required List<BonusTransactionEntity> transactions,
    required int totalItems,
    required int totalPages,
  }) = _BonusTransactionResponseEntity;
}
