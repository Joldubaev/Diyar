import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/domain/usecases/verify_sms_code_and_handle_first_launch_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/refresh_token_if_needed_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._authRepository,
    this._verifySmsCodeUseCase,
    this._refreshTokenUseCase,
  ) : super(SignInInitial());

  final AuthRepository _authRepository;
  final VerifySmsCodeAndHandleFirstLaunchUseCase _verifySmsCodeUseCase;
  final RefreshTokenIfNeededUseCase _refreshTokenUseCase;

  /// Send SMS code for login.
  Future<void> sendSmsCode(String phone) async {
    emit(SignInLoading());
    final result = await _authRepository.sendVerificationCode(phone);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(SmsCodeSentForLogin(phone)),
    );
  }

  Future<void> sendSmsCodeForLogin(String phone) => sendSmsCode(phone);

  /// Verify SMS code and handle first launch.
  Future<void> verifySmsCode(String phone, String code) async {
    emit(SignInLoading());
    final result = await _verifySmsCodeUseCase(phone, code);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(SignInSuccessWithUser()),
    );
  }

  Future<void> verifySmsCodeForLogin(String phone, String code) =>
      verifySmsCode(phone, code);

  /// Send code for password reset.
  Future<void> sendForgotPasswordCode(String phone) async {
    emit(SignInLoading());
    final result = await _authRepository.sendForgotPasswordCodeToPhone(phone);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }

  Future<void> sendCode(String phone) => sendForgotPasswordCode(phone);

  /// Reset password.
  Future<void> resetPassword(ResetPasswordEntity model) async {
    emit(SignInLoading());
    final result = await _authRepository.resetPassword(model);
    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }

  /// Refresh token if expired.
  Future<void> refreshTokenIfNeeded() async {
    final result = await _refreshTokenUseCase();
    result.fold(
      (failure) => emit(RefreshTokenFailure()),
      (_) => emit(RefreshTokenLoaded()),
    );
  }

  Future<void> refreshToken() => refreshTokenIfNeeded();

  /// Logout.
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure('Ошибка при выходе: $e'));
    }
  }

  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }
}
