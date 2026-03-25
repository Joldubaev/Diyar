import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';

abstract interface class IOpenBankingRepository {
  Future<Either<Failure, String>> createPayLink({
    required int amount,
    required String orderNumber,
  });
}
