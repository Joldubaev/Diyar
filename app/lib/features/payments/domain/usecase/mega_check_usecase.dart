import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class MegaCheckUseCase {
  final PaymentsRepository repository;
  MegaCheckUseCase(this.repository);

  Future<Either<Failure, String>> call(PaymentsEntity entity) {
    return repository.checkPaymentMega(entity);
  }
}
