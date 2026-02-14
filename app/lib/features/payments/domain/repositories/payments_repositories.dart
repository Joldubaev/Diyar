import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/domain/domain.dart';

abstract interface class PaymentsRepository {
  Future<Either<Failure, String>> checkPaymentMega(PaymentsEntity entity);
  Future<Either<Failure, String>> megaInitiate(PaymentsEntity entity);
  Future<Either<Failure, String>> megaStatus(String orderNumber);
  Future<Either<Failure, MbankEntity>> mbankConfirm(PaymentsEntity entity);
  Future<Either<Failure, String>> mbankStatus(String orderNumber);

  Future<Either<Failure, MbankEntity>> mbankInitiate(PaymentsEntity entity);
  Future<Either<Failure, QrCodeEntity>> qrGenerate(int amount);
  Future<Either<Failure, QrPaymentStatusEntity>> qrCheckStatus(String transactionId, String orderNumber);
}
