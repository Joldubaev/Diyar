/// Абстракция для безопасного хранения данных (токены, настройки)
/// Domain слой не должен зависеть от конкретных реализаций хранилища
abstract class SecureStorageService {
  // Первый запуск
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();

  // Токены (для usecases, которые работают с токенами)
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserRole();
}

