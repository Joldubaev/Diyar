import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для отправки SMS кода верификации
@injectable
class SendVerificationCodeUseCase {
  final AuthRepository _repository;

  SendVerificationCodeUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone) async {
    return _repository.sendVerificationCode(phone);
  }
}
