import 'package:bloc/bloc.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/profile/data/data.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;
  ProfileCubit(this._userRepository) : super(ProfileInitial());

  UserModel? user;

  Future getUser() async {
    emit(ProfileGetLoading());
    try {
      user = await _userRepository.getUser();
      emit(ProfileGetLoaded(user!));
    } catch (e) {
      emit(ProfileGetError());
    }
  }
}
