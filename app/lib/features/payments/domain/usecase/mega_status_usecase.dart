import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/payments.dart';
import 'package:injectable/injectable.dart';

@injectable
class MegaStatusUsecase {
  final PaymentsRepository repository;
  MegaStatusUsecase(this.repository);

  Future<Either<Failure, String>> megaStatus(String orderNumber) {
    return repository.megaStatus(orderNumber);
  }
}
