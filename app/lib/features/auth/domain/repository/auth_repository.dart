import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';

abstract class AuthRepository {
  // 🔐 Registration
  Future<Either<Failure, void>> register(UserEntities user);
  Future<Either<Failure, bool>> checkPhoneNumber(String phone);
  Future<Either<Failure, void>> sendVerificationCode(String phone);
  Future<Either<Failure, void>> verifyCodeForRegistration(String phone, String code);

  // 🔓 Login & Auth
  Future<Either<Failure, void>> verifyCodeForLogin(String phone, String code);
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);
  Future<Either<Failure, void>> resetPassword(ResetPasswordEntity model);
  Future<Either<Failure, void>> refreshToken();
  Future<void> logout();

  // pin code
  Future<void> setPinCode(String code);
  Future<String?> getPinCode();
}
