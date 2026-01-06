import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для получения настройки биометрии
@injectable
class GetBiometricPreferenceUseCase {
  final SecureStorageService _secureStorage;

  GetBiometricPreferenceUseCase(this._secureStorage);

  Future<bool> call() async {
    return _secureStorage.getBiometricPreference();
  }
}

