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

  const SignInSuccess({
    this.phone,
  });

  @override
  List<Object?> get props => [phone];
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

/// Успешный выход (для обратной совместимости)
final class LogoutSuccess extends SignInState {
  const LogoutSuccess();
}

/// Успешное обновление токена (для обратной совместимости)
final class RefreshTokenLoaded extends SignInState {
  const RefreshTokenLoaded();
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
