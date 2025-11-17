import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/data/models/reset_password_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, void>> login(UserEntities user) {
    return remoteDataSource.login(UserModel.fromEntity(user));
  }

  @override
  Future<Either<Failure, void>> register(UserEntities user) {
    return remoteDataSource.register(UserModel.fromEntity(user));
  }

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phone) {
    return remoteDataSource.checkPhoneNumber(phone);
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(String phone) {
    return remoteDataSource.sendVerificationCode(phone);
  }

  @override
  Future<Either<Failure, void>> verifyCode(String phone, String code) {
    return remoteDataSource.verifyCode(phone, code);
  }

  @override
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone) {
    return remoteDataSource.sendForgotPasswordCodeToPhone(phone);
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordEntity model) {
    return remoteDataSource.confirmResetPassword(ResetPasswordModel.fromEntity(model));
  }

  @override
  Future<Either<Failure, void>> refreshToken() {
    return remoteDataSource.refreshToken();
  }

  @override
  Future<void> setPinCode(String code) {
    return localDataSource.setPinCode(code);
  }

  @override
  Future<String?> getPinCode() {
    return localDataSource.getPinCode();
  }

  @override
  Future<void> logout() {
    return localDataSource.logout();
  }
}
