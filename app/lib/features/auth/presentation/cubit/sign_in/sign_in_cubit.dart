import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/domain/usecases/verify_sms_code_and_handle_first_launch_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/refresh_token_if_needed_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/check_biometrics_availability_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/authenticate_with_biometrics_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._authRepository,
    this._localStorage,
    this._verifySmsCodeUseCase,
    this._refreshTokenUseCase,
    this._checkBiometricsUseCase,
    this._authenticateBiometricsUseCase,
  ) : super(SignInInitial());

  final AuthRepository _authRepository;
  final LocalStorage _localStorage;
  final VerifySmsCodeAndHandleFirstLaunchUseCase _verifySmsCodeUseCase;
  final RefreshTokenIfNeededUseCase _refreshTokenUseCase;
  final CheckBiometricsAvailabilityUseCase _checkBiometricsUseCase;
  final AuthenticateWithBiometricsUseCase _authenticateBiometricsUseCase;

  /// Отправка SMS кода для логина
  Future<void> sendSmsCode(String phone) async {
    emit(SignInLoading());

    final result = await _authRepository.sendVerificationCode(phone);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(SmsCodeSentForLogin(phone)),
    );
  }

  /// Отправка SMS кода для логина (алиас для обратной совместимости)
  Future<void> sendSmsCodeForLogin(String phone) => sendSmsCode(phone);

  /// Верификация SMS кода
  Future<void> verifySmsCode(String phone, String code) async {
    emit(SignInLoading());

    final result = await _verifySmsCodeUseCase(phone, code);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(SignInSuccessWithUser()),
    );
  }

  /// Верификация SMS кода для логина (алиас для обратной совместимости)
  Future<void> verifySmsCodeForLogin(String phone, String code) => verifySmsCode(phone, code);

  /// Отправка кода для сброса пароля
  Future<void> sendForgotPasswordCode(String phone) async {
    emit(SignInLoading());

    final result = await _authRepository.sendForgotPasswordCodeToPhone(phone);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }

  /// Отправка кода (алиас для обратной совместимости)
  Future<void> sendCode(String phone) => sendForgotPasswordCode(phone);

  /// Сброс пароля
  Future<void> resetPassword(ResetPasswordEntity model) async {
    emit(SignInLoading());

    final result = await _authRepository.resetPassword(model);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }

  /// Обновление токена, если необходимо
  Future<void> refreshTokenIfNeeded() async {
    final result = await _refreshTokenUseCase();
    result.fold(
      (failure) => emit(RefreshTokenFailure()),
      (_) => emit(RefreshTokenLoaded()),
    );
  }

  /// Обновление токена (алиас для обратной совместимости)
  Future<void> refreshToken() => refreshTokenIfNeeded();

  /// Установка PIN кода
  Future<void> setPinCode(String code) async {
    emit(SignInLoading());

    try {
      await _authRepository.setPinCode(code);
      emit(PinCodeSetSuccess());
    } catch (e) {
      emit(PinCodeSetFailure('Не удалось сохранить PIN-код: ${e.toString()}'));
    }
  }

  /// Получение PIN кода
  Future<void> getPinCode() async {
    emit(SignInLoading());

    try {
      final pinCode = await _authRepository.getPinCode();
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
    final result = await _checkBiometricsUseCase();
    if (result.isAvailable) {
      emit(BiometricAvailable(result.isEnabled));
    } else {
      emit(BiometricNotAvailable());
    }
  }

  /// Аутентификация по биометрии
  Future<void> authenticateWithBiometrics() async {
    emit(BiometricAuthenticating());

    final result = await _authenticateBiometricsUseCase();
    if (result.isSuccess) {
      emit(BiometricAuthenticationSuccess());
    } else {
      emit(BiometricAuthenticationFailure(result.errorMessage ?? 'Ошибка аутентификации'));
    }
  }

  /// Сохранение настройки биометрии
  Future<void> saveBiometricPreference(bool isEnabled) async {
    try {
      await _localStorage.setBool(AppConst.biometricPrefKey, isEnabled);
      emit(BiometricPreferenceSaved(isEnabled));
      await checkBiometricsAvailability();
    } catch (e) {
      emit(BiometricPreferenceFailure('Не удалось сохранить настройку биометрии'));
    }
  }

  /// Получение настройки биометрии
  bool getBiometricPreference() {
    return _localStorage.getBool(AppConst.biometricPrefKey) ?? false;
  }

  /// Выход
  Future<void> logout() async {
    try {
      await _localStorage.delete(AppConst.biometricPrefKey);
      await _authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure('Ошибка при выходе: ${e.toString()}'));
    }
  }

  /// Форматирование номера телефона
  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }
}
