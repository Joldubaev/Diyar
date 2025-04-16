part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileGetLoading extends ProfileState {}

class ProfileGetLoaded extends ProfileState {
  final UserModel userModel;

  const ProfileGetLoaded(this.userModel);

  @override
  List<Object> get props => [userModel];
}

class ProfileGetError extends ProfileState {}

// Delete user

class ProfileDeleteLoading extends ProfileState {}

class ProfileDeleteLoaded extends ProfileState {}

class ProfileDeleteError extends ProfileState {}
