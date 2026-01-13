import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для регистрации пользователя
@injectable
class RegisterUserUseCase {
  final AuthRepository _repository;

  RegisterUserUseCase(this._repository);

  Future<Either<Failure, void>> call(UserEntities user) async {
    return _repository.register(user);
  }
}

