import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/domain/usecases/verify_sms_code_and_handle_first_launch_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/refresh_token_if_needed_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/send_verification_code_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._verifySmsCodeUseCase,
    this._refreshTokenUseCase,
    this._sendVerificationCodeUseCase,
    this._logoutUseCase,
  ) : super(SignInInitial());

  final VerifySmsCodeAndHandleFirstLaunchUseCase _verifySmsCodeUseCase;
  final RefreshTokenIfNeededUseCase _refreshTokenUseCase;
  final SendVerificationCodeUseCase _sendVerificationCodeUseCase;
  final LogoutUseCase _logoutUseCase;

  /// Отправка SMS кода для логина
  Future<void> sendSmsCode(String phone) async {
    emit(SignInLoading());

    final result = await _sendVerificationCodeUseCase(phone);
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

  /// Отправка SMS кода (алиас для обратной совместимости)
  Future<void> sendCode(String phone) => sendSmsCode(phone);

  /// Выход
  Future<void> logout() async {
    try {
      await _logoutUseCase();
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
