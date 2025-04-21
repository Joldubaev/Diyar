part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccessWithUser extends SignInState {}

final class SignOutSuccess extends SignInState {}

final class ForgotPasswordSuccess extends SignInState {}

final class ResetPasswordSuccess extends SignInState {}

final class SignInFailure extends SignInState {
  final String message;
  SignInFailure(this.message);
}

final class RefreshTokenLoading extends SignInState {}

final class RefreshTokenLoaded extends SignInState {}

final class RefreshTokenFailure extends SignInState {}
