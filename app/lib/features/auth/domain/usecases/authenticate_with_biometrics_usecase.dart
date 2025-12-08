import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:diyar/core/utils/storage/local_storage.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';

/// Use case для аутентификации по биометрии
@injectable
class AuthenticateWithBiometricsUseCase {
  final LocalAuthentication _localAuth;
  final LocalStorage _localStorage;

  AuthenticateWithBiometricsUseCase(this._localAuth, this._localStorage);

  Future<BiometricAuthResult> call() async {
    try {
      // Проверка доступности
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        return BiometricAuthResult.failure('Биометрия недоступна на этом устройстве');
      }

      final isEnabled = _localStorage.getBool(AppConst.biometricPrefKey) ?? false;
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

/// Результат аутентификации по биометрии
class BiometricAuthResult {
  final bool isSuccess;
  final String? errorMessage;

  BiometricAuthResult._({required this.isSuccess, this.errorMessage});

  factory BiometricAuthResult.success() => BiometricAuthResult._(isSuccess: true);
  factory BiometricAuthResult.failure(String message) => BiometricAuthResult._(isSuccess: false, errorMessage: message);
}
