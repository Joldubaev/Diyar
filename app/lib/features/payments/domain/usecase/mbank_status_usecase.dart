import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class MbankStatusUsecase {
  final PaymentsRepository repository;
  MbankStatusUsecase(this.repository);
  Future<Either<Failure, String>> mbankStatus(String orderNumber) {
    return repository.mbankStatus(orderNumber);
  }
}
