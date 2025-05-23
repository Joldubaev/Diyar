import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/profile/profile.dart';
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
    final result = await _userRepository.getUser();
    result.fold(
      (failure) => emit(ProfileGetError()),
      (loadedUser) {
        user = loadedUser;
        emit(ProfileGetLoaded(loadedUser));
      },
    );
  }

  Future<void> deleteUser() async {
    emit(ProfileDeleteLoading());
    final result = await _userRepository.deleteUser();
    result.fold(
      (failure) => emit(ProfileDeleteError()),
      (_) => emit(ProfileDeleteLoaded()),
    );
  }

  Future<void> updateUser(String name, String phone) async {
    emit(ProfileUpdateLoading());
    final result = await _userRepository.updateUser(name, phone);
    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (message) {
        emit(ProfileUpdateLoaded(message));

        getUser();
      },
    );
  }
}
