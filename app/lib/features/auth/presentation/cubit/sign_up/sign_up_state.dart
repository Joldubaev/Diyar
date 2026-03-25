part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

// Основные стейты регистрации
final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess();
}

final class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Стейты для проверки номера телефона
final class CheckPhoneLoading extends SignUpState {
  const CheckPhoneLoading();
}

final class CheckPhoneSuccess extends SignUpState {
  const CheckPhoneSuccess();
}

final class CheckPhoneFailure extends SignUpState {
  final String message;

  const CheckPhoneFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Стейты для отправки кода верификации
final class SendCodeLoading extends SignUpState {
  const SendCodeLoading();
}

final class SendCodeSuccess extends SignUpState {
  const SendCodeSuccess();
}

final class SendCodeFailure extends SignUpState {
  final String message;

  const SendCodeFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Стейты для верификации кода
final class VerifyCodeLoading extends SignUpState {
  const VerifyCodeLoading();
}

final class VerifyCodeSuccess extends SignUpState {
  const VerifyCodeSuccess();
}

final class VerifyCodeFailure extends SignUpState {
  final String message;

  const VerifyCodeFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// SMS for reset password
final class SmsResetPasswordLoading extends SignUpState {
  const SmsResetPasswordLoading();
}

final class SmsResetPasswordLoaded extends SignUpState {
  const SmsResetPasswordLoaded();
}

final class SmsResetPasswordError extends SignUpState {
  const SmsResetPasswordError();
}

// SMS for register user
final class SmsSignUpLoading extends SignUpState {
  const SmsSignUpLoading();
}

final class SmsSignUpLoaded extends SignUpState {
  const SmsSignUpLoaded();
}

final class SmsSignUpError extends SignUpState {
  const SmsSignUpError();
}
