import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:diyar/core/utils/storage/local_storage.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';

/// Use case для проверки доступности биометрии
@injectable
class CheckBiometricsAvailabilityUseCase {
  final LocalAuthentication _localAuth;
  final LocalStorage _localStorage;

  CheckBiometricsAvailabilityUseCase(this._localAuth, this._localStorage);

  Future<BiometricAvailabilityResult> call() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        final isEnabled = _localStorage.getBool(AppConst.biometricPrefKey) ?? false;
        return BiometricAvailabilityResult.available(isEnabled);
      } else {
        return BiometricAvailabilityResult.notAvailable();
      }
    } catch (e) {
      return BiometricAvailabilityResult.notAvailable();
    }
  }
}

/// Результат проверки доступности биометрии
class BiometricAvailabilityResult {
  final bool isAvailable;
  final bool isEnabled;

  BiometricAvailabilityResult._({
    required this.isAvailable,
    required this.isEnabled,
  });

  factory BiometricAvailabilityResult.available(bool enabled) =>
      BiometricAvailabilityResult._(isAvailable: true, isEnabled: enabled);

  factory BiometricAvailabilityResult.notAvailable() =>
      BiometricAvailabilityResult._(isAvailable: false, isEnabled: false);
}
