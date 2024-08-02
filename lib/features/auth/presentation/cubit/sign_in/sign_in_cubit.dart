import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/shared.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.authRepository) : super(SignInInitial());

  final AuthRepository authRepository;

  void signInUser(UserModel model) async {
    emit(SignInLoading());
    try {
      await authRepository.login(model);
      emit(SignInSuccessWithUser());
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  void sendCodeToPhone(String phone) async {
    emit(SignInLoading());
    try {
      await authRepository.sendForgotPasswordCodeToPhone(phone);
      emit(FogotPasswordSuccess());
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  void resetPassword({required ResetModel model}) async {
    emit(SignInLoading());
    try {
      await authRepository.resetPassword(model: model);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  Future logout() async => await authRepository.logout();

  Future refreshToken() async {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    if (token != null && JwtDecoder.isExpired(token)) {
      emit(RefreshTokenLoading());
      try {
        await authRepository.refreshToken();
        emit(RefreshTokenLoaded());
      } catch (e) {
        emit(RefreshTokenFailure());
      } finally {
        log('Token isExpired: ${JwtDecoder.isExpired(token)}');
      }
    } else {
      emit(RefreshTokenLoaded());
    }
  }
}
