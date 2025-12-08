import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/data/models/reset_password_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, void>> register(UserModel user);
  Future<Either<Failure, bool>> checkPhoneNumber(String phone);
  Future<Either<Failure, void>> sendVerificationCode(String phone);
  Future<Either<Failure, void>> verifyCodeForLogin(String phone, String code);
  Future<Either<Failure, void>> verifyCodeForRegistration(String phone, String code);
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model);
  Future<Either<Failure, void>> refreshToken();
}
