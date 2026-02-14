import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class MbankInitiateUsecase {
  final PaymentsRepository repository;
  MbankInitiateUsecase(this.repository);
  Future<Either<Failure, MbankEntity>> call(PaymentsEntity request) async {
    return await repository.mbankInitiate(request);
  }
}
