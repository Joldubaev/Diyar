/// Абстракция для безопасного хранения данных (PIN, токены, настройки)
/// Domain слой не должен зависеть от конкретных реализаций хранилища
abstract class SecureStorageService {
  // PIN код
  Future<void> setPinCode(String code);
  Future<String?> getPinCode();

  // Первый запуск
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();

  // Настройки биометрии
  Future<void> setBiometricPreference(bool enabled);
  Future<bool> getBiometricPreference();

  // Токены (для usecases, которые работают с токенами)
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserRole();
}

