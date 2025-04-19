import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit(this.authRepository) : super(SignUpInitial());

  // 🔐 Регистрация
  Future<void> signUpUser(UserEntities model) async {
    emit(SignUpLoading());

    final res = await authRepository.register(model);
    res.fold(
      (failure) => emit(SignUpFailure(failure.message)),
      (_) => emit(SignUpSuccess()),
    );
  }

  // 📞 Проверка номера
  Future<void> checkPhoneNumber(String phone) async {
    emit(CheckPhoneLoading());

    final res = await authRepository.checkPhoneNumber(phone);
    res.fold(
      (failure) => emit(CheckPhoneFailure(failure.message)),
      (_) => emit(CheckPhoneSuccess()),
    );
  }

  // 📤 Отправка кода
  Future<void> sendVerificationCode(String phone) async {
    emit(SendCodeLoading());

    final res = await authRepository.sendVerificationCode(phone);
    res.fold(
      (failure) => emit(SendCodeFailure(failure.message)),
      (_) => emit(SendCodeSuccess()),
    );
  }

  // ✅ Подтверждение кода
  Future<void> verifyCode(String phone, String code) async {
    emit(VerifyCodeLoading());

    final res = await authRepository.verifyCode(phone, code);
    res.fold(
      (failure) => emit(VerifyCodeFailure(failure.message)),
      (_) => emit(VerifyCodeSuccess()),
    );
  }
}
