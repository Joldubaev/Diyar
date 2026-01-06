import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для получения PIN кода
@injectable
class GetPinCodeUseCase {
  final SecureStorageService _secureStorage;

  GetPinCodeUseCase(this._secureStorage);

  Future<String?> call() async {
    return _secureStorage.getPinCode();
  }
}

