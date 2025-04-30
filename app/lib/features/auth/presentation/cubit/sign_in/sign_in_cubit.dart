import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/injection_container.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart'; // Для PlatformException
import 'package:local_auth/local_auth.dart'; // Импорт local_auth

part 'sign_in_state.dart';

// Ключ для сохранения настройки биометрии в LocalStorage
const String _biometricPrefKey = 'biometric_enabled';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(SignInInitial());

  final AuthRepository _authRepository;
  final LocalStorage _localStorage = sl<LocalStorage>();
  final LocalAuthentication _localAuth = LocalAuthentication(); // Экземпляр LocalAuthentication

  // 🔐 Вход
  Future<void> signIn(UserEntities model) async {
    emit(SignInLoading());

    final res = await _authRepository.login(model);
    res.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(SignInSuccessWithUser()),
    );
  }

  // 📤 Отправка кода для сброса пароля
  Future<void> sendCode(String phone) async {
    emit(SignInLoading());

    final res = await _authRepository.sendForgotPasswordCodeToPhone(phone);
    res.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }

  // 🔄 Сброс пароля
  Future<void> resetPassword(ResetPasswordEntity model) async {
    emit(SignInLoading());

    final res = await _authRepository.resetPassword(model);
    res.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }

  // 🔁 Обновление токена
  Future<void> refreshToken() async {
    final token = _localStorage.getString(AppConst.accessToken);

    if (token != null && JwtDecoder.isExpired(token)) {
      emit(RefreshTokenLoading());

      final res = await _authRepository.refreshToken();
      res.fold(
        (failure) => emit(RefreshTokenFailure()),
        (_) => emit(RefreshTokenLoaded()),
      );

      log('Token isExpired: ${JwtDecoder.isExpired(token)}');
    } else {
      emit(RefreshTokenLoaded());
    }
  }

  // pin code
  Future<void> setPinCode(String code) async {
    emit(SignInLoading());
    try {
      await _authRepository.setPinCode(code);
      emit(PinCodeSetSuccess());
    } on Exception catch (e) {
      emit(PinCodeSetFailure(e.toString()));
    }
  }

  Future<void> getPinCode() async {
    emit(SignInLoading());
    try {
      final String? pinCode = await _authRepository.getPinCode();
      if (pinCode == null) {
        emit(PinCodeGetFailure("PIN code is not set or could not be retrieved."));
      } else {
        emit(PinCodeGetSuccess(pinCode));
      }
    } on Exception catch (e) {
      emit(PinCodeGetFailure(e.toString()));
    }
  }

  // --- Методы для биометрии ---

  /// Проверяет доступность биометрии и сохраненную настройку пользователя
  Future<void> checkBiometricsAvailability() async {
    emit(BiometricInitial());
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        final bool isEnabled = _localStorage.getBool(_biometricPrefKey) ?? false;
        emit(BiometricAvailable(isEnabled));
      } else {
        emit(BiometricNotAvailable());
      }
    } catch (e) {
      log('Error checking biometrics: $e');
      emit(BiometricNotAvailable()); // Считаем недоступной при ошибке
    }
  }

  /// Запускает аутентификацию по биометрии
  Future<void> authenticateWithBiometrics() async {
    // Проверяем еще раз на всякий случай
    final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final bool isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      emit(BiometricAuthenticationFailure("Биометрия недоступна на этом устройстве."));
      return;
    }

    final bool isEnabled = _localStorage.getBool(_biometricPrefKey) ?? false;
    if (!isEnabled) {
      emit(BiometricAuthenticationFailure("Вход по биометрии не включен в настройках."));
      return;
    }

    emit(BiometricAuthenticating());
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Пожалуйста, подтвердите вход', // Локализованная строка
        options: const AuthenticationOptions(
          stickyAuth: true, // Оставаться на экране аутентификации
          biometricOnly: true, // Использовать только биометрию (не PIN/пароль устройства)
        ),
      );

      if (didAuthenticate) {
        emit(BiometricAuthenticationSuccess());
      } else {
        emit(BiometricAuthenticationFailure("Аутентификация отменена или не удалась."));
      }
    } on PlatformException catch (e) {
      log('Biometric PlatformException: ${e.code} - ${e.message}');
      // Обработка специфичных ошибок, если нужно (e.g., e.code == error_code.notAvailable)
      emit(BiometricAuthenticationFailure("Ошибка биометрии: ${e.message ?? 'Неизвестная ошибка'}"));
    } catch (e) {
      log('Biometric generic error: $e');
      emit(BiometricAuthenticationFailure("Произошла ошибка при аутентификации."));
    }
  }

  /// Сохраняет настройку использования биометрии
  Future<void> saveBiometricPreference(bool isEnabled) async {
    try {
      await _localStorage.setBool(_biometricPrefKey, isEnabled);
      emit(BiometricPreferenceSaved(isEnabled));
      // После сохранения снова проверяем доступность, чтобы обновить состояние BiometricAvailable
      await checkBiometricsAvailability();
    } catch (e) {
      log('Error saving biometric preference: $e');
      emit(BiometricPreferenceFailure("Не удалось сохранить настройку биометрии."));
    }
  }

  /// Получает текущую настройку биометрии (для инициализации UI)
  bool getBiometricPreference() {
    return _localStorage.getBool(_biometricPrefKey) ?? false;
  }

  // 🚪 Выход
  Future<void> logout() async {
    // Добавляем async, так как удаляем настройку
    // При выходе сбрасываем настройку биометрии
    await _localStorage.delete(_biometricPrefKey);
    await _authRepository.logout();
    emit(LogoutSuccess()); // Эмитим успех после очистки
  }

  // 🔧 Хелпер
  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }
}
