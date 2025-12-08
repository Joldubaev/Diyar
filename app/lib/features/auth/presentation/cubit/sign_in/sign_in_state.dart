part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

/// Начальное состояние
final class SignInInitial extends SignInState {}

/// Состояние загрузки
final class SignInLoading extends SignInState {}

/// Успешное состояние
final class SignInSuccess extends SignInState {
  final String? phone;
  final String? pinCode;
  final bool? biometricEnabled;

  SignInSuccess({
    this.phone,
    this.pinCode,
    this.biometricEnabled,
  });
}

/// Успешный вход с пользователем (для обратной совместимости)
final class SignInSuccessWithUser extends SignInState {}

/// SMS код отправлен для логина (для обратной совместимости)
final class SmsCodeSentForLogin extends SignInState {
  final String phone;
  SmsCodeSentForLogin(this.phone);
}

/// Успешный сброс пароля (для обратной совместимости)
final class ResetPasswordSuccess extends SignInState {}

/// Успешная отправка кода для сброса пароля (для обратной совместимости)
final class ForgotPasswordSuccess extends SignInState {}

/// Успешная установка PIN кода (для обратной совместимости)
final class PinCodeSetSuccess extends SignInState {}

/// Успешное получение PIN кода (для обратной совместимости)
final class PinCodeGetSuccess extends SignInState {
  final String pinCode;
  PinCodeGetSuccess(this.pinCode);
}

/// Успешный выход (для обратной совместимости)
final class LogoutSuccess extends SignInState {}

/// Успешное обновление токена (для обратной совместимости)
final class RefreshTokenLoaded extends SignInState {}

/// Биометрия доступна (для обратной совместимости)
final class BiometricAvailable extends SignInState {
  final bool isBiometricEnabled;
  BiometricAvailable(this.isBiometricEnabled);
}

/// Биометрия недоступна (для обратной совместимости)
final class BiometricNotAvailable extends SignInState {}

/// Начальное состояние биометрии (для обратной совместимости)
final class BiometricInitial extends SignInState {}

/// Аутентификация по биометрии успешна (для обратной совместимости)
final class BiometricAuthenticationSuccess extends SignInState {}

/// Идет процесс аутентификации по биометрии (для обратной совместимости)
final class BiometricAuthenticating extends SignInState {}

/// Состояние ошибки
final class SignInError extends SignInState {
  final String message;
  SignInError(this.message);
}

/// Ошибка входа (для обратной совместимости)
final class SignInFailure extends SignInState {
  final String message;
  SignInFailure(this.message);
}

/// Ошибка установки PIN кода (для обратной совместимости)
final class PinCodeSetFailure extends SignInState {
  final String message;
  PinCodeSetFailure(this.message);
}

/// Ошибка получения PIN кода (для обратной совместимости)
final class PinCodeGetFailure extends SignInState {
  final String message;
  PinCodeGetFailure(this.message);
}

/// Ошибка выхода (для обратной совместимости)
final class LogoutFailure extends SignInState {
  final String message;
  LogoutFailure(this.message);
}

/// Ошибка обновления токена (для обратной совместимости)
final class RefreshTokenFailure extends SignInState {}

/// Ошибка аутентификации по биометрии (для обратной совместимости)
final class BiometricAuthenticationFailure extends SignInState {
  final String message;
  BiometricAuthenticationFailure(this.message);
}

/// Настройка биометрии сохранена (для обратной совместимости)
final class BiometricPreferenceSaved extends SignInState {
  final bool isEnabled;
  BiometricPreferenceSaved(this.isEnabled);
}

/// Ошибка сохранения настройки биометрии (для обратной совместимости)
final class BiometricPreferenceFailure extends SignInState {
  final String message;
  BiometricPreferenceFailure(this.message);
}
