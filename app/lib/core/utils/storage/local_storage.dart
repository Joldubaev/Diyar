import 'package:shared_preferences/shared_preferences.dart';

import 'storage_exception.dart';

/// ```dart
/// // Create a `LocalStorage` instance.
/// final storage = await LocalStorage.getInstance();
///
/// // Write a key/value pair.
/// await storage.setString(key: 'my_key', value: 'my_value');
///
/// // Read value for key.
/// final value = storage.getString(key: 'my_key'); // 'my_value'
/// ```
class LocalStorage {
  const LocalStorage._(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Returns a new instance of [LocalStorage].
  ///
  /// If [SharedPreferences] is not provided, the default instance will be used.
  static Future<LocalStorage> getInstance([SharedPreferences? pref]) async {
    return LocalStorage._(pref ?? await SharedPreferences.getInstance());
  }

  String? getString(String key) {
    try {
      return _sharedPreferences.getString(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  bool? getBool(String key) {
    try {
      return _sharedPreferences.getBool(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  double? getDouble(String key) {
    try {
      return _sharedPreferences.getDouble(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  int? getInt(String key) {
    try {
      return _sharedPreferences.getInt(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _sharedPreferences.getStringList(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> setString(String key, String value) {
    try {
      return _sharedPreferences.setString(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> setBool(String key, bool value) {
    try {
      return _sharedPreferences.setBool(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> setDouble(String key, double value) {
    try {
      return _sharedPreferences.setDouble(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> setInt(String key, int value) {
    try {
      return _sharedPreferences.setInt(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> setStringList(String key, List<String> value) {
    try {
      return _sharedPreferences.setStringList(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> delete(String key) async {
    try {
      return _sharedPreferences.remove(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  Future<bool> clear() {
    try {
      return _sharedPreferences.clear();
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }
}
