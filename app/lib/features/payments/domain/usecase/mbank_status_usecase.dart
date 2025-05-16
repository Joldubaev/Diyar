import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/domain/domain.dart';

class MbankStatusUsecase {
  final PaymentsRepository repository;
  MbankStatusUsecase(this.repository);
  Future<Either<Failure, String>> mbankStatus(String orderNumber) {
    return repository.mbankStatus(orderNumber);
  }
}
