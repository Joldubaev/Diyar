abstract class SecureStorage {
  /// Сохраняет значение по ключу
  Future<void> save(String key, String value);

  /// Читает значение по ключу
  Future<String?> read(String key);

  /// Удаляет значение по ключу
  Future<void> delete(String key);

  /// Проверяет наличие значения по ключу
  Future<bool> contains(String key);

  /// Очищает все значения
  Future<void> clear();


}
