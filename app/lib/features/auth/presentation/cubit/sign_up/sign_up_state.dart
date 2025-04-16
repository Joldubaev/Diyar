part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {}

final class SignedUpState extends SignUpState {}

final class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure(this.message);
}

// SMS for reset password

final class SmsResetPasswordLoading extends SignUpState {}

final class SmsResetPasswordLoaded extends SignUpState {}

final class SmsResetPasswordError extends SignUpState {}

// SMS for register user

final class SmsSignUpLoading extends SignUpState {}

final class SmsSignUpLoaded extends SignUpState {}

final class SmsSignUpError extends SignUpState {}
