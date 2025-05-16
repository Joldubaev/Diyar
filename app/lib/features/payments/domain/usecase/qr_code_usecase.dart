import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/domain/domain.dart';

class QrCodeUsecase {
  final PaymentsRepository repository;
  QrCodeUsecase(this.repository);
  Future<Either<Failure, QrCodeEntity>> call( int amount) async {
    return repository.qrGenerate(amount);
  }
}
