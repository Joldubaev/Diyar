import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

/// Тип маршрута для навигации (domain не должен знать про auto_route)
enum NavigationRouteType {
  /// Главный экран для обычных пользователей
  main,
  /// Экран для курьеров
  courier,
  /// Экран входа
  signIn,
  /// Экран PIN кода
  pinCode,
  /// Экран установки PIN кода
  pinCodeSetup,
}

/// Use case для определения маршрута навигации на основе роли пользователя
@injectable
class GetNavigationRouteUseCase {
  final SecureStorageService _secureStorage;

  GetNavigationRouteUseCase(this._secureStorage);

  Future<NavigationRouteType> call() async {
    final role = await _secureStorage.getUserRole();
    
    if (role == 'Courier') {
      return NavigationRouteType.courier;
    }
    
    return NavigationRouteType.main;
  }
}

