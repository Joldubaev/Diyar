import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _userRepository;
  ProfileCubit(this._userRepository) : super(ProfileInitial());

  UserModel? user;

  Future<void> getUser() async {
    final isAuth = UserHelper.isAuth();
    if (!isAuth) return;

    emit(ProfileGetLoading());
    try {
      user = await _userRepository.getUser();
      emit(ProfileGetLoaded(user!));
    } catch (e) {
      emit(ProfileGetError());
    }
  }

  deleteUser() async {
    emit(ProfileDeleteLoading());
    try {
      await _userRepository.deleteUser();
      emit(ProfileDeleteLoaded());
    } catch (e) {
      emit(ProfileDeleteError());
    }
  }
}
