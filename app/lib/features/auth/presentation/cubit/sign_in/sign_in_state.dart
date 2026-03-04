part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
final class SignInInitial extends SignInState {
  const SignInInitial();
}

/// Состояние загрузки
final class SignInLoading extends SignInState {
  const SignInLoading();
}

/// Успешное состояние
final class SignInSuccess extends SignInState {
  final String? phone;
  final String? pinCode;
  final bool? biometricEnabled;

  const SignInSuccess({
    this.phone,
    this.pinCode,
    this.biometricEnabled,
  });

  @override
  List<Object?> get props => [phone, pinCode, biometricEnabled];
}

/// Успешный вход с пользователем (для обратной совместимости)
final class SignInSuccessWithUser extends SignInState {
  const SignInSuccessWithUser();
}

/// SMS код отправлен для логина (для обратной совместимости)
final class SmsCodeSentForLogin extends SignInState {
  final String phone;
  const SmsCodeSentForLogin(this.phone);

  @override
  List<Object?> get props => [phone];
}

/// Успешный сброс пароля (для обратной совместимости)
final class ResetPasswordSuccess extends SignInState {
  const ResetPasswordSuccess();
}

/// Успешная отправка кода для сброса пароля (для обратной совместимости)
final class ForgotPasswordSuccess extends SignInState {
  const ForgotPasswordSuccess();
}

/// Успешная установка PIN кода (для обратной совместимости)
final class PinCodeSetSuccess extends SignInState {
  const PinCodeSetSuccess();
}

/// Успешное получение PIN кода (для обратной совместимости)
final class PinCodeGetSuccess extends SignInState {
  final String pinCode;
  const PinCodeGetSuccess(this.pinCode);

  @override
  List<Object?> get props => [pinCode];
}

/// Успешный выход (для обратной совместимости)
final class LogoutSuccess extends SignInState {
  const LogoutSuccess();
}

/// Успешное обновление токена (для обратной совместимости)
final class RefreshTokenLoaded extends SignInState {
  const RefreshTokenLoaded();
}

/// Биометрия доступна (для обратной совместимости)
final class BiometricAvailable extends SignInState {
  final bool isBiometricEnabled;
  const BiometricAvailable(this.isBiometricEnabled);

  @override
  List<Object?> get props => [isBiometricEnabled];
}

/// Биометрия недоступна (для обратной совместимости)
final class BiometricNotAvailable extends SignInState {
  const BiometricNotAvailable();
}

/// Начальное состояние биометрии (для обратной совместимости)
final class BiometricInitial extends SignInState {
  const BiometricInitial();
}

/// Аутентификация по биометрии успешна (для обратной совместимости)
final class BiometricAuthenticationSuccess extends SignInState {
  const BiometricAuthenticationSuccess();
}

/// Идет процесс аутентификации по биометрии (для обратной совместимости)
final class BiometricAuthenticating extends SignInState {
  const BiometricAuthenticating();
}

/// Состояние ошибки
final class SignInError extends SignInState {
  final String message;
  const SignInError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Ошибка входа (для обратной совместимости)
final class SignInFailure extends SignInState {
  final String message;
  const SignInFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Ошибка установки PIN кода (для обратной совместимости)
final class PinCodeSetFailure extends SignInState {
  final String message;
  const PinCodeSetFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Ошибка получения PIN кода (для обратной совместимости)
final class PinCodeGetFailure extends SignInState {
  final String message;
  const PinCodeGetFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Ошибка выхода (для обратной совместимости)
final class LogoutFailure extends SignInState {
  final String message;
  const LogoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Ошибка обновления токена (для обратной совместимости)
final class RefreshTokenFailure extends SignInState {
  const RefreshTokenFailure();
}

/// Ошибка аутентификации по биометрии (для обратной совместимости)
final class BiometricAuthenticationFailure extends SignInState {
  final String message;
  const BiometricAuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Настройка биометрии сохранена (для обратной совместимости)
final class BiometricPreferenceSaved extends SignInState {
  final bool isEnabled;
  const BiometricPreferenceSaved(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

/// Ошибка сохранения настройки биометрии (для обратной совместимости)
final class BiometricPreferenceFailure extends SignInState {
  final String message;
  const BiometricPreferenceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
