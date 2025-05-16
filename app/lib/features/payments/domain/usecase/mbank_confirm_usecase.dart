import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/domain/domain.dart';

class MbankConfimUsecase {
   final PaymentsRepository repository;
  MbankConfimUsecase(this.repository);
  Future<Either<Failure, MbankEntity>> call(PaymentsEntity request) async {
    return await repository.mbankConfirm(request);
  }
}