import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/payments/data/datasource/remote_payments_datasource.dart';
import 'package:diyar/features/payments/data/models/model.dart';
import 'package:diyar/features/payments/domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PaymentsRepository)
class PaymentsRepositoryImpl implements PaymentsRepository {
  final RemotePaymentsDatasource remotePaymentsDatasource;

  PaymentsRepositoryImpl(this.remotePaymentsDatasource);

  @override
  Future<Either<Failure, String>> checkPaymentMega(PaymentsEntity entity) async {
    final model = PaymentsModel.fromEntity(entity);
    final result = await remotePaymentsDatasource.checkPaymentMega(model);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, String>> megaInitiate(PaymentsEntity entity) {
    final model = PaymentsModel.fromEntity(entity);
    return remotePaymentsDatasource.megaInitiate(model);
  }

  @override
  Future<Either<Failure, String>> megaStatus(String orderNumber) {
    return remotePaymentsDatasource.megaStatus(orderNumber);
  }

  @override
  Future<Either<Failure, MbankEntity>> mbankInitiate(PaymentsEntity entity) async {
    final model = PaymentsModel.fromEntity(entity);
    final result = await remotePaymentsDatasource.mbankInitiate(model);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, MbankEntity>> mbankConfirm(PaymentsEntity entity) async {
    final model = PaymentsModel.fromEntity(entity);
    final result = await remotePaymentsDatasource.mbankConfirm(model);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> mbankStatus(String orderNumber) {
    return remotePaymentsDatasource.mbankStatus(orderNumber);
  }

  @override
  Future<Either<Failure, QrCodeEntity>> qrGenerate(int amount) async {
    final result = await remotePaymentsDatasource.qrGenerate(amount);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, QrPaymentStatusEntity>> qrCheckStatus(String transactionId, String orderNumber) async {
    return remotePaymentsDatasource.qrCheckStatus(transactionId, orderNumber).then(
          (result) => result.fold(
            (failure) => Left(failure),
            (model) => Right(model.toEntity()),
          ),
        );
  }
}
