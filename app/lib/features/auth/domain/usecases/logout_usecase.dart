import 'package:diyar/features/auth/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case для выхода из системы
@injectable
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call() async {
    return _repository.logout();
  }
}

