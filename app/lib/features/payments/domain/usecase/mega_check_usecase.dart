import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/payments/domain/domain.dart';

class MegaCheckUseCase {
  final PaymentsRepository repository;
  MegaCheckUseCase(this.repository);

  Future<Either<Failure, MegaCheckEntity>> call(PaymentsEntity entity) {
    return repository.checkPaymentMega(entity);
  }
}
