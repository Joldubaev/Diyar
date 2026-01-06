part of 'security_cubit.dart';

@immutable
sealed class SecurityState {}

/// Начальное состояние
final class SecurityInitial extends SecurityState {}

/// Состояние загрузки
final class SecurityLoading extends SecurityState {}

/// PIN код успешно установлен
final class SecurityPinCodeSetSuccess extends SecurityState {}

/// Ошибка установки PIN кода
final class SecurityPinCodeSetFailure extends SecurityState {
  final String message;

  SecurityPinCodeSetFailure(this.message);
}

/// Биометрия доступна
final class SecurityBiometricAvailable extends SecurityState {
  final bool isEnabled;

  SecurityBiometricAvailable(this.isEnabled);
}

/// Биометрия недоступна
final class SecurityBiometricNotAvailable extends SecurityState {}

/// Настройка биометрии сохранена
final class SecurityBiometricPreferenceSaved extends SecurityState {
  final bool isEnabled;

  SecurityBiometricPreferenceSaved(this.isEnabled);
}

/// Ошибка сохранения настройки биометрии
final class SecurityBiometricPreferenceFailure extends SecurityState {
  final String message;

  SecurityBiometricPreferenceFailure(this.message);
}

