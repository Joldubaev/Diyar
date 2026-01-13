import 'package:bloc/bloc.dart';
import 'package:diyar/features/app_init/domain/usecases/check_authentication_status_usecase.dart';
import 'package:diyar/features/auth/domain/usecases/refresh_token_if_needed_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final CheckAuthenticationStatusUseCase _checkAuthenticationStatusUseCase;
  final RefreshTokenIfNeededUseCase _refreshTokenIfNeededUseCase;

  SplashCubit(
    this._checkAuthenticationStatusUseCase,
    this._refreshTokenIfNeededUseCase,
  ) : super(SplashInitial());

  /// Проверка статуса аутентификации
  Future<void> checkAuthenticationStatus() async {
    emit(SplashLoading());

    try {
      final status = await _checkAuthenticationStatusUseCase();
      emit(SplashAuthenticationStatusLoaded(status));
    } catch (e) {
      emit(SplashError('Ошибка при проверке статуса аутентификации'));
    }
  }

  /// Обновление токена, если необходимо
  Future<void> refreshTokenIfNeeded() async {
    try {
      final result = await _refreshTokenIfNeededUseCase();
      result.fold(
        (failure) => emit(SplashTokenRefreshFailed()),
        (_) => emit(SplashTokenRefreshed()),
      );
    } catch (e) {
      emit(SplashTokenRefreshFailed());
    }
  }
}

