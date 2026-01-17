/// Абстракция для биометрической аутентификации
/// Domain слой не должен зависеть от конкретных реализаций Flutter/платформы
abstract class BiometricAuthService {
  /// Результат проверки доступности биометрии
  Future<BiometricAvailabilityResult> checkAvailability();

  /// Выполнить аутентификацию по биометрии
  Future<BiometricAuthResult> authenticate();
}

/// Результат проверки доступности биометрии
class BiometricAvailabilityResult {
  final bool isAvailable;
  final bool isEnabled;

  const BiometricAvailabilityResult._({
    required this.isAvailable,
    required this.isEnabled,
  });

  factory BiometricAvailabilityResult.available(bool enabled) =>
      BiometricAvailabilityResult._(isAvailable: true, isEnabled: enabled);

  factory BiometricAvailabilityResult.notAvailable() =>
      const BiometricAvailabilityResult._(isAvailable: false, isEnabled: false);
}

/// Результат аутентификации по биометрии
class BiometricAuthResult {
  final bool isSuccess;
  final String? errorMessage;

  const BiometricAuthResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory BiometricAuthResult.success() =>
      const BiometricAuthResult._(isSuccess: true);

  factory BiometricAuthResult.failure(String message) =>
      BiometricAuthResult._(isSuccess: false, errorMessage: message);
}

