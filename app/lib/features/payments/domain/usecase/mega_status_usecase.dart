import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/payments.dart';

class MegaStatusUsecase {
  final PaymentsRepository repository;
  MegaStatusUsecase(this.repository);

  Future<Either<Failure, String>> megaStatus(String orderNumber) {
    return repository.megaStatus(orderNumber);
  }
}
