import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/data/data.dart';
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

  String unformatPhoneNumber(String formattedPhoneNumber) {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D'), '');
  }

  void sendRegisterSms({required String code, required String phone}) async {
    emit(SmsSignUpLoading());
    try {
      String unformattedPhone = unformatPhoneNumber(phone);
      await _smsRepository.sendSms(code, unformattedPhone);
      emit(SmsSignUpLoaded());
    } catch (e) {
      emit(SmsSignUpError());
    }
  }
}
