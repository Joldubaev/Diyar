import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _userRepository;
  ProfileCubit(this._userRepository) : super(ProfileInitial());

  static const _cacheDuration = Duration(minutes: 5);

  DateTime? _lastLoaded;
  bool _isLoading = false;

  UserProfileModel? user;

  Future<void> getUser({bool force = false}) async {
    final isAuth = UserHelper.isAuth();
    if (!isAuth) return;

    if (_isLoading) return;

    if (!force &&
        _lastLoaded != null &&
        DateTime.now().difference(_lastLoaded!) < _cacheDuration) {
      return;
    }

    _isLoading = true;
    emit(ProfileGetLoading());

    try {
      final result = await _userRepository.getUser();
      result.fold(
        (failure) => emit(ProfileGetError()),
        (loadedUser) {
          user = loadedUser;
          emit(ProfileGetLoaded(loadedUser));
          _lastLoaded = DateTime.now();
        },
      );
    } finally {
      _isLoading = false;
    }
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
