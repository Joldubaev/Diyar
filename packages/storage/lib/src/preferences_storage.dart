import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/src/interface/preferences_storage_interface.dart';

class PreferencesStorageImpl implements PreferencesStorage {
  @override
  Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
