part of 'pin_code_cubit.dart';

@immutable
sealed class PinCodeState {}

/// Начальное состояние
final class PinCodeInitial extends PinCodeState {}

/// Состояние загрузки
final class PinCodeLoading extends PinCodeState {}

/// PIN код успешно получен
final class PinCodeGetSuccess extends PinCodeState {
  final String pinCode;

  PinCodeGetSuccess(this.pinCode);
}

/// Ошибка получения PIN кода
final class PinCodeGetFailure extends PinCodeState {
  final String message;

  PinCodeGetFailure(this.message);
}

/// Биометрия доступна
final class PinCodeBiometricAvailable extends PinCodeState {
  final bool isEnabled;

  PinCodeBiometricAvailable(this.isEnabled);
}

/// Биометрия недоступна
final class PinCodeBiometricNotAvailable extends PinCodeState {}

/// Идет процесс аутентификации по биометрии
final class PinCodeBiometricAuthenticating extends PinCodeState {}

/// Аутентификация по биометрии успешна
final class PinCodeBiometricAuthenticationSuccess extends PinCodeState {}

/// Ошибка аутентификации по биометрии
final class PinCodeBiometricAuthenticationFailure extends PinCodeState {
  final String message;

  PinCodeBiometricAuthenticationFailure(this.message);
}

/// Маршрут навигации загружен
final class PinCodeNavigationRouteLoaded extends PinCodeState {
  final NavigationRouteType routeType;

  PinCodeNavigationRouteLoaded(this.routeType);
}

/// Ошибка получения маршрута навигации
final class PinCodeNavigationRouteFailure extends PinCodeState {
  final String message;

  PinCodeNavigationRouteFailure(this.message);
}

/// Ошибка валидации PIN кода
final class PinCodeValidationFailure extends PinCodeState {
  final String message;

  PinCodeValidationFailure(this.message);
}

