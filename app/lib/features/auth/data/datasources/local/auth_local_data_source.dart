import 'dart:convert';
import 'package:diyar/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:storage/storage.dart';

abstract class AuthLocalDataSource {
  Future<String?> getLangFromCache();
  Future<void> logout();
  Future<void> setLangToCache(String langCode);
  Future<void> setUserToCache(TokenModel user);
  String? getUserFromCache();
  Future<void> setTokenToCache({String? refresh, required String access, String phone});
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunchCompleted();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage prefs;
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.prefs, this.secureStorage);

  @override
  Future<String?> getLangFromCache() async {
    return prefs.getString(AppConst.langCode);
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        prefs.clear(),
        secureStorage.clear(),
      ]);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setLangToCache(String langCode) async {
    try {
      await prefs.setString(AppConst.langCode, langCode);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setTokenToCache({
    String? refresh,
    required String access,
    String? phone,
  }) async {
    try {
      // Primary: зашифрованное хранилище (flutter_secure_storage)
      await secureStorage.save(AppConst.accessToken, access);
      // Backward-compat: оставляем копию в SharedPreferences для datasource,
      // которые ещё читают токен через prefs.getString / _localStorage.getString.
      await prefs.setString(AppConst.accessToken, access);

      if (refresh != null) {
        await secureStorage.save(AppConst.refreshToken, refresh);
        await prefs.setString(AppConst.refreshToken, refresh);
      }

      if (phone != null) {
        await prefs.setString(AppConst.phone, phone);
      }

      final payload = JwtDecoder.decode(access);
      final userId = payload['nameid'];
      final role = payload['role'];

      await prefs.setString(AppConst.userId, userId?.toString() ?? '');
      await prefs.setString(AppConst.userRole, role?.toString() ?? '');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setUserToCache(TokenModel user) async {
    try {
      var userString = user.toJson();
      await prefs.setString(AppConst.userInfo, jsonEncode(userString));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  String? getUserFromCache() {
    try {
      var jsonUser = prefs.getString(AppConst.userInfo);
      if (jsonUser != null) {
        return TokenModel.fromJson(jsonDecode(jsonUser)).role;
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isFirstLaunch() async {
    try {
      return prefs.getBool(AppConst.firstLaunch) ?? true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    try {
      await prefs.setBool(AppConst.firstLaunch, false);
    } catch (e) {
      throw CacheException();
    }
  }
}
