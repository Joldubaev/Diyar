import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/domain/entities/entities.dart';

abstract class BonusRepository {
  Future<Either<Failure, QrGenerateEntity>> generateQr();
  Future<Either<Failure, BonusTransactionResponseEntity>> getBonusTransactions({
    int page = 1,
    int pageSize = 50,
    String? userId,
    String? transactionType,
    String? dateFrom,
    String? dateTo,
  });
}
