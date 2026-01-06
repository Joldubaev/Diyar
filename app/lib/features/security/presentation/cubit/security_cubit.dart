import 'package:bloc/bloc.dart';
import 'package:diyar/features/security/domain/usecases/set_pin_code_usecase.dart';
import 'package:diyar/features/security/domain/usecases/save_biometric_preference_usecase.dart';
import 'package:diyar/features/security/domain/usecases/get_biometric_preference_usecase.dart';
import 'package:diyar/features/security/domain/usecases/check_biometrics_availability_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'security_state.dart';

@injectable
class SecurityCubit extends Cubit<SecurityState> {
  final SetPinCodeUseCase _setPinCodeUseCase;
  final SaveBiometricPreferenceUseCase _saveBiometricPreferenceUseCase;
  final GetBiometricPreferenceUseCase _getBiometricPreferenceUseCase;
  final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailabilityUseCase;

  SecurityCubit(
    this._setPinCodeUseCase,
    this._saveBiometricPreferenceUseCase,
    this._getBiometricPreferenceUseCase,
    this._checkBiometricsAvailabilityUseCase,
  ) : super(SecurityInitial());

  /// Установка PIN кода
  Future<void> setPinCode(String code) async {
    emit(SecurityLoading());

    try {
      await _setPinCodeUseCase(code);
      emit(SecurityPinCodeSetSuccess());
    } catch (e) {
      emit(SecurityPinCodeSetFailure('Не удалось сохранить PIN-код: ${e.toString()}'));
    }
  }

  /// Сохранение настройки биометрии
  Future<void> saveBiometricPreference(bool isEnabled) async {
    try {
      await _saveBiometricPreferenceUseCase(isEnabled);
      emit(SecurityBiometricPreferenceSaved(isEnabled));
      await checkBiometricsAvailability();
    } catch (e) {
      emit(SecurityBiometricPreferenceFailure('Не удалось сохранить настройку биометрии'));
    }
  }

  /// Получение настройки биометрии
  Future<bool> getBiometricPreference() async {
    return _getBiometricPreferenceUseCase();
  }

  /// Проверка доступности биометрии
  Future<void> checkBiometricsAvailability() async {
    final result = await _checkBiometricsAvailabilityUseCase();
    if (result.isAvailable) {
      emit(SecurityBiometricAvailable(result.isEnabled));
    } else {
      emit(SecurityBiometricNotAvailable());
    }
  }
}

