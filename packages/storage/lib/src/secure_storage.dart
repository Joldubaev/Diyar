import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:storage/src/interface/secure_storage_interface.dart';

class SecureStorageImpl implements SecureStorage {
  // iOS: first_unlock_this_device — значения доступны после первой разблокировки
  // (в т.ч. при работе в фоне с заблокированным экраном) и не переносятся
  // через backup на другое устройство. Без этого Keychain по умолчанию
  // использует whenUnlocked и read() возвращает null при заблокированном экране.
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      // Keychain временно недоступен (например, errSecInteractionNotAllowed).
      // Возвращаем null, а не бросаем — вызывающий код не должен трактовать
      // это как «токена нет».
      return null;
    }
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
