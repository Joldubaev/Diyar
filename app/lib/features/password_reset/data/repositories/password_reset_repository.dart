import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/domain/domain.dart';
import 'package:diyar/features/password_reset/data/datasources/remote/password_reset_remote_data_source.dart';
import 'package:diyar/features/password_reset/data/models/reset_password_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PasswordResetRepository)
class PasswordResetRepositoryImpl implements PasswordResetRepository {
  final PasswordResetRemoteDataSource _remoteDataSource;

  PasswordResetRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone) {
    return _remoteDataSource.sendForgotPasswordCodeToPhone(phone);
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordEntity model) {
    return _remoteDataSource.confirmResetPassword(ResetPasswordModel.fromEntity(model));
  }
}

