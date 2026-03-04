part of 'splash_cubit.dart';

@immutable
sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Состояние загрузки
final class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Статус аутентификации загружен
final class SplashAuthenticationStatusLoaded extends SplashState {
  final AuthenticationStatus status;

  const SplashAuthenticationStatusLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

/// Токен обновлен
final class SplashTokenRefreshed extends SplashState {
  const SplashTokenRefreshed();
}

/// Ошибка обновления токена
final class SplashTokenRefreshFailed extends SplashState {
  const SplashTokenRefreshFailed();
}

/// Ошибка
final class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}

