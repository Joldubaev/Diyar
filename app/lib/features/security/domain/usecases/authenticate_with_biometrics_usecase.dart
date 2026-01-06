import 'package:diyar/features/security/domain/services/biometric_auth_service.dart';
import 'package:injectable/injectable.dart';

/// Use case для аутентификации по биометрии
@injectable
class AuthenticateWithBiometricsUseCase {
  final BiometricAuthService _biometricAuthService;

  AuthenticateWithBiometricsUseCase(this._biometricAuthService);

  Future<BiometricAuthResult> call() async {
    return _biometricAuthService.authenticate();
  }
}

