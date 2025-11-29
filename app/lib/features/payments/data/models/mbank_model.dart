import 'package:diyar/features/payments/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mbank_model.freezed.dart';

@freezed
class MbankModel with _$MbankModel {
  const factory MbankModel({
    int? amount,
    String? quid,
    DateTime? dateTime,
  }) = _MbankModel;

  factory MbankModel.fromJson(Map<String, dynamic> json) {
    return MbankModel(
      amount: json['amount'] as int?,
      quid: json['quid'] as String?,
      dateTime: _dateTimeFromJson(json['dateTime']),
    );
  }

  factory MbankModel.fromEntity(MbankEntity entity) => MbankModel(
        amount: entity.amount,
        quid: entity.quid,
        dateTime: entity.dateTime,
      );
}

DateTime? _dateTimeFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) {
    return DateTime.tryParse(json);
  }
  if (json is int) {
    return DateTime.fromMillisecondsSinceEpoch(json);
  }
  return null;
}

extension MbankModelX on MbankModel {
  MbankEntity toEntity() => MbankEntity(
        amount: amount,
        quid: quid,
        dateTime: dateTime,
      );
}
