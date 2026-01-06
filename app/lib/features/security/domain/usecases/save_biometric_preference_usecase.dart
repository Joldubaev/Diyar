import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для сохранения настройки биометрии
@injectable
class SaveBiometricPreferenceUseCase {
  final SecureStorageService _secureStorage;

  SaveBiometricPreferenceUseCase(this._secureStorage);

  Future<void> call(bool enabled) async {
    return _secureStorage.setBiometricPreference(enabled);
  }
}

