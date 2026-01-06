import 'package:diyar/features/security/domain/services/biometric_auth_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для проверки доступности биометрии
@injectable
class CheckBiometricsAvailabilityUseCase {
  final BiometricAuthService _biometricAuthService;

  CheckBiometricsAvailabilityUseCase(this._biometricAuthService);

  Future<BiometricAvailabilityResult> call() async {
    return _biometricAuthService.checkAvailability();
  }
}

