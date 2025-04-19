part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

// Основные стейты регистрации
final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {}

final class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure(this.message);
}

// Стейты для проверки номера телефона
final class CheckPhoneLoading extends SignUpState {}

final class CheckPhoneSuccess extends SignUpState {}

final class CheckPhoneFailure extends SignUpState {
  final String message;

  CheckPhoneFailure(this.message);
}

// Стейты для отправки кода верификации
final class SendCodeLoading extends SignUpState {}

final class SendCodeSuccess extends SignUpState {}

final class SendCodeFailure extends SignUpState {
  final String message;

  SendCodeFailure(this.message);
}

// Стейты для верификации кода
final class VerifyCodeLoading extends SignUpState {}

final class VerifyCodeSuccess extends SignUpState {}

final class VerifyCodeFailure extends SignUpState {
  final String message;

  VerifyCodeFailure(this.message);
}

// SMS for reset password

final class SmsResetPasswordLoading extends SignUpState {}

final class SmsResetPasswordLoaded extends SignUpState {}

final class SmsResetPasswordError extends SignUpState {}

// SMS for register user

final class SmsSignUpLoading extends SignUpState {}

final class SmsSignUpLoaded extends SignUpState {}

final class SmsSignUpError extends SignUpState {}
