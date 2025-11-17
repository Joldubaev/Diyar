import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:injectable/injectable.dart';

@injectable
class MegaInitiateUsecase {
  final PaymentsRepository repository;
  MegaInitiateUsecase(this.repository);

  Future<Either<Failure, String>> megaInitiate(PaymentsEntity entity) {
    return repository.megaInitiate(entity);
  }
}
