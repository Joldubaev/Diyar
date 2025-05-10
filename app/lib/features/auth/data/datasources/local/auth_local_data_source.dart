import 'dart:convert';
import 'dart:developer';
import 'package:diyar/core/core.dart';
import 'package:diyar/shared/shared.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AuthLocalDataSource {
  Future<String?> getPinCode();
  Future<void> setPinCode(String pinCode);
  Future<String?> getLangFromCache();
  Future<void> logout();
  Future<void> setLangToCache(String langCode);
  Future<void> setUserToCache(TokenModel user);
  String? getUserFromCache();
  Future<void> setTokenToCache({String? refresh, required String access, String phone});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage prefs;

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<String?> getLangFromCache() async {
    return prefs.getString(AppConst.langCode);
  }

  @override
  Future<void> logout() async {
    try {
      await prefs.clear();
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
      log("[CACHE SAVE] Attempting to save tokens.");
      log("[CACHE SAVE] Access Token to be saved: $access");
      if (refresh != null) {
        log("[CACHE SAVE] Refresh Token to be saved: $refresh");
        await prefs.setString(AppConst.refreshToken, refresh);
      }
      await prefs.setString(AppConst.accessToken, access);
      log("[CACHE SAVE] Access Token WRITTEN to prefs with key ${AppConst.accessToken}");

      if (phone != null) {
        await prefs.setString(AppConst.phone, phone);
        log('[CACHE SAVE] Phone saved: $phone');
      }

      final payload = JwtDecoder.decode(access);
      final userId = payload['nameid'];
      final role = payload['role'];

      log('[CACHE SAVE] UserID from token: $userId');
      log('[CACHE SAVE] Role from token: $role');

      await prefs.setString(AppConst.userId, userId);
      await prefs.setString(AppConst.userRole, role);
      log("[CACHE SAVE] Tokens and user info saved successfully.");
    } catch (e) {
      log('[CACHE ERROR] Failed to save tokens: $e');
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
  Future<String?> getPinCode() async {
    try {
      return prefs.getString(AppConst.pinCode);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setPinCode(String pinCode) async {
    try {
      await prefs.setString(AppConst.pinCode, pinCode);
    } catch (e) {
      throw CacheException();
    }
  }
}
