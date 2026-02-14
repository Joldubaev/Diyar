import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Результат проверки статуса аутентификации
enum AuthenticationStatus {
  /// Первый запуск приложения
  firstLaunch,
  /// Токен отсутствует или истек
  unauthenticated,
  /// Полностью аутентифицирован
  authenticated,
}

/// Use case для проверки статуса аутентификации
@injectable
class CheckAuthenticationStatusUseCase {
  final SecureStorageService _secureStorage;

  CheckAuthenticationStatusUseCase(this._secureStorage);

  Future<AuthenticationStatus> call() async {
    // Проверка первого запуска
    final isFirstLaunch = await _secureStorage.isFirstLaunch();
    if (isFirstLaunch) {
      return AuthenticationStatus.firstLaunch;
    }

    // Проверка токенов
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken == null) {
      return AuthenticationStatus.unauthenticated;
    }

    final accessToken = await _secureStorage.getAccessToken();
    if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
      return AuthenticationStatus.unauthenticated;
    }

    return AuthenticationStatus.authenticated;
  }
}

