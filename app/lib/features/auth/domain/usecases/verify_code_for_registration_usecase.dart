import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для верификации кода при регистрации
@injectable
class VerifyCodeForRegistrationUseCase {
  final AuthRepository _repository;

  VerifyCodeForRegistrationUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone, String code) async {
    return _repository.verifyCodeForRegistration(phone, code);
  }
}

