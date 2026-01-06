import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для установки PIN кода
@injectable
class SetPinCodeUseCase {
  final SecureStorageService _secureStorage;

  SetPinCodeUseCase(this._secureStorage);

  Future<void> call(String code) async {
    return _secureStorage.setPinCode(code);
  }
}

