import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:diyar/core/constants/constant.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/injection_container.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(SignInInitial());

  final AuthRepository _authRepository;

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
    final token = sl<SharedPreferences>().getString(AppConst.accessToken);

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

  // 🚪 Выход
  Future<void> logout() => _authRepository.logout();

  // 🔧 Хелпер
  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }
}
