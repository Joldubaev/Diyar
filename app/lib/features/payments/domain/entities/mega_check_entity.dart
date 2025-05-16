import 'package:equatable/equatable.dart';

class MegaCheckEntity extends Equatable {
  final int? commission;
  final int? amount;

  const MegaCheckEntity({
    this.commission,
    this.amount,
  });

  @override
  List<Object?> get props => [
        commission,
        amount,
      ];
}
