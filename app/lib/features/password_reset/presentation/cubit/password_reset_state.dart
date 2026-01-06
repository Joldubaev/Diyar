part of 'password_reset_cubit.dart';

@immutable
sealed class PasswordResetState {}

/// Начальное состояние
final class PasswordResetInitial extends PasswordResetState {}

/// Состояние загрузки
final class PasswordResetLoading extends PasswordResetState {}

/// Код для сброса пароля отправлен
final class PasswordResetCodeSent extends PasswordResetState {}

/// Пароль успешно сброшен
final class PasswordResetSuccess extends PasswordResetState {}

/// Ошибка
final class PasswordResetFailure extends PasswordResetState {
  final String message;

  PasswordResetFailure(this.message);
}

