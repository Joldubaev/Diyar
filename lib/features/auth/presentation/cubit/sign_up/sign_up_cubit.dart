import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/data/data.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/auth/data/repositories/sms_repository.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SmsRepository _smsRepository;
  final AuthRepository authRepository;

  SignUpCubit(
    this.authRepository,
    this._smsRepository,
  ) : super(SignUpInitial());

  void signUpUser(UserModel model) async {
    emit(SignUpLoading());
    try {
      final user = await authRepository.register(model);
      emit(SignUpSuccess());
      return user;
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  void sendRegisterSms({required String code, required String phone}) async {
    emit(SmsSignUpLoading());
    try {
      await _smsRepository.sendSms(code, phone);
      emit(SmsSignUpLoaded());
    } catch (e) {
      emit(SmsSignUpError());
    }
  }
}
