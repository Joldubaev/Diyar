import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/domain/entities/reset_password_entity.dart';

abstract class PasswordResetRepository {
  /// Отправить код для сброса пароля на телефон
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);

  /// Сбросить пароль
  Future<Either<Failure, void>> resetPassword(ResetPasswordEntity model);
}

