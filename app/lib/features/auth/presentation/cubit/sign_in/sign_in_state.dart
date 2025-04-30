part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccessWithUser extends SignInState {}

final class SignOutSuccess extends SignInState {}

final class ForgotPasswordSuccess extends SignInState {}

final class ResetPasswordSuccess extends SignInState {}

final class SignInFailure extends SignInState {
  final String message;
  SignInFailure(this.message);
}

final class RefreshTokenLoading extends SignInState {}

final class RefreshTokenLoaded extends SignInState {}

final class RefreshTokenFailure extends SignInState {}

final class PinCodeSetSuccess extends SignInState {}

final class PinCodeSetFailure extends SignInState {
  final String message;
  PinCodeSetFailure(this.message);
}

final class PinCodeGetSuccess extends SignInState {
  final String pinCode;
  PinCodeGetSuccess(this.pinCode);
}

final class PinCodeGetFailure extends SignInState {
  final String message;
  PinCodeGetFailure(this.message);
}

final class LogoutSuccess extends SignInState {}

final class LogoutFailure extends SignInState {
  final String message;
  LogoutFailure(this.message);
}

// --- Состояния для биометрии ---

// Начальное состояние или проверка
final class BiometricInitial extends SignInState {}

// Биометрия доступна и включена пользователем
final class BiometricAvailable extends SignInState {
  final bool isBiometricEnabled;
  BiometricAvailable(this.isBiometricEnabled);
}

// Биометрия недоступна на устройстве
final class BiometricNotAvailable extends SignInState {}

// Идет процесс аутентификации по биометрии
final class BiometricAuthenticating extends SignInState {}

// Аутентификация по биометрии успешна
final class BiometricAuthenticationSuccess extends SignInState {}

// Ошибка аутентификации по биометрии
final class BiometricAuthenticationFailure extends SignInState {
  final String message;
  BiometricAuthenticationFailure(this.message);
}

// Настройка биометрии сохранена
final class BiometricPreferenceSaved extends SignInState {
  final bool isEnabled;
  BiometricPreferenceSaved(this.isEnabled);
}

// Ошибка сохранения настройки биометрии
final class BiometricPreferenceFailure extends SignInState {
  final String message;
  BiometricPreferenceFailure(this.message);
}
