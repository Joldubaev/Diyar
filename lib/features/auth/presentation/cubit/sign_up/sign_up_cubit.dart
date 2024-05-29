import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/data/data.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(
    this.authRepository,
  ) : super(SignUpInitial());

  final AuthRepository authRepository;

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
}
