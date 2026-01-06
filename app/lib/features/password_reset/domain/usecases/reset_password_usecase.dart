import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/domain/entities/reset_password_entity.dart';
import 'package:diyar/features/password_reset/domain/repository/password_reset_repository.dart';
import 'package:injectable/injectable.dart';

/// Use case для сброса пароля
@injectable
class ResetPasswordUseCase {
  final PasswordResetRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(ResetPasswordEntity model) async {
    return _repository.resetPassword(model);
  }
}

