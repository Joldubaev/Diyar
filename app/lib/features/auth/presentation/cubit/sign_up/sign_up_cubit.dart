import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/check_phone_number_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/send_verification_code_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/verify_code_for_registration_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final RegisterUserUseCase _registerUserUseCase;
  final CheckPhoneNumberUseCase _checkPhoneNumberUseCase;
  final SendVerificationCodeUseCase _sendVerificationCodeUseCase;
  final VerifyCodeForRegistrationUseCase _verifyCodeForRegistrationUseCase;

  SignUpCubit(
    this._registerUserUseCase,
    this._checkPhoneNumberUseCase,
    this._sendVerificationCodeUseCase,
    this._verifyCodeForRegistrationUseCase,
  ) : super(SignUpInitial());

  Future<void> signUpUser(UserEntities model) async {
    emit(SignUpLoading());

    final res = await _registerUserUseCase(model);
    res.fold(
      (failure) => emit(SignUpFailure(failure.message)),
      (_) => emit(SignUpSuccess()),
    );
  }

  Future<void> checkPhoneNumber(String phone) async {
    emit(CheckPhoneLoading());

    final res = await _checkPhoneNumberUseCase(phone);
    res.fold(
      (failure) => emit(CheckPhoneFailure(failure.message)),
      (_) => emit(CheckPhoneSuccess()),
    );
  }

  Future<void> sendVerificationCode(String phone) async {
    emit(SendCodeLoading());

    final res = await _sendVerificationCodeUseCase(phone);
    res.fold(
      (failure) => emit(SendCodeFailure(failure.message)),
      (_) => emit(SendCodeSuccess()),
    );
  }

  Future<void> verifyCode(String phone, String code) async {
    emit(VerifyCodeLoading());

    final res = await _verifyCodeForRegistrationUseCase(phone, code);
    res.fold(
      (failure) => emit(VerifyCodeFailure(failure.message)),
      (_) => emit(VerifyCodeSuccess()),
    );
  }
}
