import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для получения роли пользователя
@injectable
class GetUserRoleUseCase {
  final SecureStorageService _secureStorage;

  GetUserRoleUseCase(this._secureStorage);

  Future<String?> call() async {
    return _secureStorage.getUserRole();
  }
}

