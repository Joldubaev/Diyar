import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:storage/src/interface/secure_storage_interface.dart';

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<bool> contains(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  @override
  Future<void> clear() async {
    await _storage.deleteAll();
  }

  // Дополнительные методы для работы с JSON
  Future<P?> getJson<P>(String key, P Function(dynamic data) parser) async {
    final jsonString = await read(key);
    if (jsonString == null) return null;
    final data = jsonDecode(jsonString);
    return parser(data);
  }

  Future<void> saveJson(String key, Object data) async {
    final value = jsonEncode(data);
    await save(key, value);
  }
}
