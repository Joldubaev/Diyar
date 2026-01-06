import 'package:diyar/features/security/domain/services/biometric_auth_service.dart';
import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@LazySingleton(as: BiometricAuthService)
class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth;
  final SecureStorageService _secureStorage;

  BiometricAuthServiceImpl(
    this._localAuth,
    this._secureStorage,
  );

  @override
  Future<BiometricAvailabilityResult> checkAvailability() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        final isEnabled = await _secureStorage.getBiometricPreference();
        return BiometricAvailabilityResult.available(isEnabled);
      } else {
        return BiometricAvailabilityResult.notAvailable();
      }
    } catch (e) {
      return BiometricAvailabilityResult.notAvailable();
    }
  }

  @override
  Future<BiometricAuthResult> authenticate() async {
    try {
      // Проверка доступности
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return BiometricAuthResult.failure('Биометрия недоступна на этом устройстве');
      }

      final isEnabled = await _secureStorage.getBiometricPreference();
      if (!isEnabled) {
        return BiometricAuthResult.failure('Вход по биометрии не включен в настройках');
      }

      // Аутентификация
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Пожалуйста, подтвердите вход',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        return BiometricAuthResult.success();
      } else {
        return BiometricAuthResult.failure('Аутентификация отменена или не удалась');
      }
    } on PlatformException catch (e) {
      return BiometricAuthResult.failure('Ошибка биометрии: ${e.message ?? 'Неизвестная ошибка'}');
    } catch (e) {
      return BiometricAuthResult.failure('Произошла ошибка при аутентификации');
    }
  }
}

