abstract class PreferencesStorage {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<bool> contains(String key);
  Future<void> clear();
}
