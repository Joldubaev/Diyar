import 'package:equatable/equatable.dart';

class BonusTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String phone;
  final String type; // "Earned", "Spent", "Adjusted"
  final double amount;
  final double balanceAfter;
  final String? description;
  final DateTime createdAt;

  const BonusTransactionEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        phone,
        type,
        amount,
        balanceAfter,
        description,
        createdAt,
      ];
}
