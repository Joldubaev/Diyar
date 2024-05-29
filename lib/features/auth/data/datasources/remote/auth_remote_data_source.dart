import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_mpdel.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(UserModel user);
  Future<void> register(UserModel user);
  Future<void> refreshToken();
  // Future<void> confirmEmail(String email, int code);
  Future<void> sendForgotPasswordCodeToEmail(String email);

  Future<void> confirmResetPassword({required ResetModel model});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSource _localDataSource;
  final SharedPreferences _prefs;
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio, this._localDataSource, this._prefs);

  // @override
  // Future<void> confirmEmail(String email, int code) async {
  //   try {
  //     var res = await _dio.post("/api/auth/email-confirm/", queryParameters: {
  //       "email": email,
  //       "confirmCode": code,
  //     });

  //     if (res.statusCode != 200) {
  //       throw ServerException();
  //     }
  //   } catch (e) {
  //     log("$e");
  //     throw ServerException();
  //   }
  // }

  @override
  Future<void> confirmResetPassword({
    required ResetModel model,
  }) async {
    try {
      var res = await _dio.post(
        ApiConst.resetPsw,
        data: {"email": model.email, "code": model.code, "newPassword": model.newPassword},
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      log("$e");
      throw ServerException();
    }
  }

  @override
  Future<void> login(UserModel user) async {
    try {
      var res = await _dio.post(ApiConst.signIn, data: {"email": user.email, "password": user.password});

      if ([200, 201].contains(res.statusCode)) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
          email: user.email!,
        );
        log("Token: ${res.data['accessToken']}");
      }
    } catch (e) {
      log("$e");
      showToast('Неверный логин или пароль', isError: true);
      throw ServerException();
    }
  }

  @override
  Future<void> register(UserModel user) async {
    try {
      var res = await _dio.post(ApiConst.signUp, data: user.toJson());

      if (res.statusCode == 200) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
          email: user.email!,
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        showToast('Пользователь с таким email уже существует', isError: true);
        throw ServerException();
      } else {
        throw DioException(
          error: 'Ошибка сервера',
          requestOptions: RequestOptions(path: ApiConst.signUp),
        );
      }
    }
  }

  @override
  Future<void> sendForgotPasswordCodeToEmail(String email) async {
    try {
      var res = await _dio.post(
        ApiConst.sendCodeToEmail,
        data: {"email": email},
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      log("$e");
      throw ServerException();
    }
  }

  @override
  Future<void> refreshToken() async {
    log("refreshToken started...");
    try {
      var res = await _dio.post(
        ApiConst.refreshToken,
        data: {"refreshToken": _prefs.getString(AppConst.refreshToken)},
      );

      if (res.statusCode == 200) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      log("$e");
      throw ServerException();
    } finally {
      log("refreshToken finished...");
    }
  }
}
