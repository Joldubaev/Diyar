import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/domain/repository/password_reset_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case для отправки кода для сброса пароля
@injectable
class SendForgotPasswordCodeUseCase {
  final PasswordResetRepository _repository;

  SendForgotPasswordCodeUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone) async {
    return _repository.sendForgotPasswordCodeToPhone(phone);
  }
}

