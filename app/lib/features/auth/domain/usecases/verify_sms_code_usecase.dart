import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для верификации SMS кода при входе
@injectable
class VerifySmsCodeUseCase {
  final AuthRepository _repository;

  VerifySmsCodeUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone, String code) async {
    return _repository.verifyCodeForLogin(phone, code);
  }
}
