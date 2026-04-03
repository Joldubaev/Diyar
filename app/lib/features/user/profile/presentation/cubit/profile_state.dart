part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileGetLoading extends ProfileState {
  const ProfileGetLoading();
}

final class ProfileGetLoaded extends ProfileState {
  final UserProfileModel userModel;

  const ProfileGetLoaded(this.userModel);

  @override
  List<Object?> get props => [userModel];
}

final class ProfileGetError extends ProfileState {
  const ProfileGetError();
}

final class ProfileDeleteLoading extends ProfileState {
  const ProfileDeleteLoading();
}

final class ProfileDeleteLoaded extends ProfileState {
  const ProfileDeleteLoaded();
}

final class ProfileDeleteError extends ProfileState {
  const ProfileDeleteError();
}

final class ProfileUpdateLoading extends ProfileState {
  const ProfileUpdateLoading();
}

final class ProfileUpdateLoaded extends ProfileState {
  final String message;

  const ProfileUpdateLoaded(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
