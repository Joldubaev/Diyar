part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

/// Начальное состояние
final class SplashInitial extends SplashState {}

/// Состояние загрузки
final class SplashLoading extends SplashState {}

/// Статус аутентификации загружен
final class SplashAuthenticationStatusLoaded extends SplashState {
  final AuthenticationStatus status;

  SplashAuthenticationStatusLoaded(this.status);
}

/// Токен обновлен
final class SplashTokenRefreshed extends SplashState {}

/// Ошибка обновления токена
final class SplashTokenRefreshFailed extends SplashState {}

/// Ошибка
final class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}

