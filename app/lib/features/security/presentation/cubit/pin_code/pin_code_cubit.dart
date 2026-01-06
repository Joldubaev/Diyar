import 'package:bloc/bloc.dart';
import 'package:diyar/features/security/domain/usecases/get_pin_code_usecase.dart';
import 'package:diyar/features/security/domain/usecases/check_biometrics_availability_usecase.dart';
import 'package:diyar/features/security/domain/usecases/authenticate_with_biometrics_usecase.dart';
import 'package:diyar/features/app_init/domain/usecases/get_navigation_route_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'pin_code_state.dart';

@injectable
class PinCodeCubit extends Cubit<PinCodeState> {
  final GetPinCodeUseCase _getPinCodeUseCase;
  final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;
  final AuthenticateWithBiometricsUseCase _authenticateWithBiometricsUseCase;
  final GetNavigationRouteUseCase _getNavigationRouteUseCase;

  PinCodeCubit(
    this._getPinCodeUseCase,
    this._checkBiometricsAvailabilityUseCase,
    this._authenticateWithBiometricsUseCase,
    this._getNavigationRouteUseCase,
  ) : super(PinCodeInitial());

  /// Получение PIN кода
  Future<void> getPinCode() async {
    emit(PinCodeLoading());

    try {
      final pinCode = await _getPinCodeUseCase();
      if (pinCode == null) {
        emit(PinCodeGetFailure('PIN-код не установлен'));
      } else {
        emit(PinCodeGetSuccess(pinCode));
      }
    } catch (e) {
      emit(PinCodeGetFailure('Не удалось получить PIN-код: ${e.toString()}'));
    }
  }

  /// Проверка доступности биометрии
  Future<void> checkBiometricsAvailability() async {
    final result = await _checkBiometricsAvailabilityUseCase();
    if (result.isAvailable) {
      emit(PinCodeBiometricAvailable(result.isEnabled));
    } else {
      emit(PinCodeBiometricNotAvailable());
    }
  }

  /// Аутентификация по биометрии
  Future<void> authenticateWithBiometrics() async {
    emit(PinCodeBiometricAuthenticating());

    final result = await _authenticateWithBiometricsUseCase();
    if (result.isSuccess) {
      emit(PinCodeBiometricAuthenticationSuccess());
    } else {
      emit(PinCodeBiometricAuthenticationFailure(
        result.errorMessage ?? 'Ошибка аутентификации',
      ));
    }
  }

  /// Получение маршрута навигации
  Future<void> getNavigationRoute() async {
    try {
      final routeType = await _getNavigationRouteUseCase();
      emit(PinCodeNavigationRouteLoaded(routeType));
    } catch (e) {
      emit(PinCodeNavigationRouteFailure('Не удалось определить маршрут'));
    }
  }

  /// Валидация введенного PIN кода
  Future<void> validatePinCode(String enteredPin, String correctPin) async {
    if (enteredPin == correctPin) {
      await getNavigationRoute();
    } else {
      emit(PinCodeValidationFailure('Неверный PIN-код'));
    }
  }
}

