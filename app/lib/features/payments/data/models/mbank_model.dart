import 'package:diyar/features/payments/domain/domain.dart';

class MbankModel {
  final int? amount;
  final String? quid;
  final DateTime? dateTime;

  MbankModel({
    this.amount,
    this.quid,
    this.dateTime,
  });

  MbankModel copyWith({
    int? amount,
    String? quid,
    DateTime? dateTime,
  }) =>
      MbankModel(
        amount: amount ?? this.amount,
        quid: quid ?? this.quid,
        dateTime: dateTime ?? this.dateTime,
      );

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'quid': quid,
      'dateTime': dateTime?.millisecondsSinceEpoch,
    };
  }

  factory MbankModel.fromJson(Map<String, dynamic> map) {
    return MbankModel(
      amount: map['amount']?.toInt(),
      quid: map['quid'],
      dateTime: map['dateTime'] != null ? DateTime.parse(map['dateTime']) : null,
    );
  }
  factory MbankModel.fromEntity(MbankEntity entity) {
    return MbankModel(
      amount: entity.amount,
      quid: entity.quid,
      dateTime: entity.dateTime,
    );
  }
  MbankEntity toEntity() {
    return MbankEntity(
      amount: amount,
      quid: quid,
      dateTime: dateTime,
    );
  }
}
