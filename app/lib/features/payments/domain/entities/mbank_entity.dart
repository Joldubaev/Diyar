import 'package:equatable/equatable.dart';

class MbankEntity extends Equatable {
  final int? amount;
  final String? quid;
  final DateTime? dateTime;

  const MbankEntity({
    this.amount,
    this.quid,
    this.dateTime,
  });

  @override
  List<Object?> get props => [
        amount,
        quid,
        dateTime,
      ];
}
