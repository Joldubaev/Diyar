import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/data/models/reset_password_model.dart';

abstract class PasswordResetRemoteDataSource {
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model);
}

