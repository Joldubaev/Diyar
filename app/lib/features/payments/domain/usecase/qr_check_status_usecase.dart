import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/payments/domain/domain.dart';

class QrCheckStatusUsecase {
  final PaymentsRepository repository;
  QrCheckStatusUsecase(this.repository);
  Future<Either<Failure, QrPaymentStatusEntity>> call(String transactionId,String orderNumber) async {
    return await repository.qrCheckStatus(transactionId, orderNumber);
  }
}
