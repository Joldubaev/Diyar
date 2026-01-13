import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для обработки первого запуска приложения
@injectable
class HandleFirstLaunchUseCase {
  final SecureStorageService _secureStorage;

  HandleFirstLaunchUseCase(this._secureStorage);

  Future<void> call() async {
    await _secureStorage.setFirstLaunchCompleted();
  }
}

