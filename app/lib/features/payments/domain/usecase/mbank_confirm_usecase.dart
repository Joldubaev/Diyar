import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class MbankConfimUsecase {
  final PaymentsRepository repository;
  MbankConfimUsecase(this.repository);
  Future<Either<Failure, MbankEntity>> call(PaymentsEntity request) async {
    return await repository.mbankConfirm(request);
  }
}
