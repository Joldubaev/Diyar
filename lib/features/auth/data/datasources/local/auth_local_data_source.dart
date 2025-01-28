import 'dart:convert';
import 'dart:developer';

import 'package:diyar/shared/models/token_model.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/core/core.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<String?> getLangFromCache();
  Future<void> logout();
  Future<void> setLangToCache(String langCode);
  Future<void> setUserToCache(TokenModel user);
  String? getUserFromCache();
  Future<void> setTokenToCache(
      {String? refresh, required String access, String phone});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

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
      if (refresh != null) {
        await prefs.setString(AppConst.refreshToken, refresh);
      }
      await prefs.setString(AppConst.accessToken, access);
      log("setTokenToCache: ${AppConst.accessToken}");
      if (phone != null) await prefs.setString(AppConst.phone, phone);
      await prefs.setString(
          AppConst.userId, JwtDecoder.decode(access)['userID']);
      await prefs.setString(
          AppConst.userRole, JwtDecoder.decode(access)['role']);
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
}
