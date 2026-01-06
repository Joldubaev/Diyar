import 'package:bloc/bloc.dart';
import 'package:diyar/features/password_reset/domain/domain.dart';
import 'package:diyar/features/password_reset/domain/usecases/send_forgot_password_code_usecase.dart';
import 'package:diyar/features/password_reset/domain/usecases/reset_password_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'password_reset_state.dart';

@injectable
class PasswordResetCubit extends Cubit<PasswordResetState> {
  final SendForgotPasswordCodeUseCase _sendForgotPasswordCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  PasswordResetCubit(
    this._sendForgotPasswordCodeUseCase,
    this._resetPasswordUseCase,
  ) : super(PasswordResetInitial());

  /// Отправка кода для сброса пароля
  Future<void> sendForgotPasswordCode(String phone) async {
    emit(PasswordResetLoading());

    final result = await _sendForgotPasswordCodeUseCase(phone);
    result.fold(
      (failure) => emit(PasswordResetFailure(failure.message)),
      (_) => emit(PasswordResetCodeSent()),
    );
  }

  /// Сброс пароля
  Future<void> resetPassword(ResetPasswordEntity model) async {
    emit(PasswordResetLoading());

    final result = await _resetPasswordUseCase(model);
    result.fold(
      (failure) => emit(PasswordResetFailure(failure.message)),
      (_) => emit(PasswordResetSuccess()),
    );
  }
}

