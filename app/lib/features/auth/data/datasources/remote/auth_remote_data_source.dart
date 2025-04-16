import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../../core/constants/constant.dart';
import '../../../../../core/core.dart';
import '../../../../features.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(UserModel user);
  Future<void> register(UserModel user);
  Future<void> refreshToken();
  Future<void> sendForgotPasswordCodeToPhone(String phone);
  Future<void> confirmResetPassword({required ResetModel model});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSource _localDataSource;
  final SharedPreferences _prefs;
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio, this._localDataSource, this._prefs);

  @override
  Future<void> confirmResetPassword({required ResetModel model}) async {
    try {
      final res = await _dio.post(
        ApiConst.resetPsw,
        data: {
          "code": model.code,
          "newPassword": model.newPassword,
          "phone": model.phone,
        },
      );

      if (res.statusCode != 200) {
        throw ServerException(
           'Ошибка сброса пароля',
          res.statusCode,
        );
      }
    } catch (e) {
      log("$e");
      if (e is DioException && e.response?.statusCode == 400) {
        final msg = e.response?.data['developerMessage'] ?? 'Ошибка сброса';
        showToast(msg, isError: true);
        throw ServerException( msg,  400);
      } else {
        showToast('Ошибка сервера', isError: true);
        throw ServerException( 'Ошибка сервера' ,null);
      }
    }
  }

  @override
  Future<void> login(UserModel user) async {
    try {
      final res = await _dio.post(
        ApiConst.signIn,
        data: {"phone": user.phone, "password": user.password},
      );

      if ([200, 201].contains(res.statusCode)) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
          phone: user.phone.toString(),
        );
        log("Token: ${res.data['accessToken']}");
      } else {
        throw ServerException( 'Неверный ответ от сервера', res.statusCode);
      }
    } catch (e) {
      log("$e");
      throw ServerException( 'Ошибка при входе', null);
    }
  }

  @override
  Future<void> register(UserModel user) async {
    try {
      final res = await _dio.post(ApiConst.signUp, data: user.toJson());

      if (res.statusCode == 200) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
          phone: user.phone.toString(),
        );
      } else {
        throw ServerException( 'Ошибка регистрации', res.statusCode);
      }
    } catch (e) {
      if (e is DioException) {
        final code = e.response?.statusCode;
        if (code == 400) {
          showToast('Пользователь с таким email уже существует', isError: true);
          throw ServerException( 'Email занят',  400);
        } else if (code == 418) {
          showToast('Пользователь с таким номером телефона уже существует', isError: true);
          throw ServerException('Телефон занят',  418);
        }
      }
      throw ServerException( 'Ошибка сервера', null);
    }
  }

  @override
  Future<void> sendForgotPasswordCodeToPhone(String phone) async {
    try {
      final res = await _dio.post(ApiConst.sendCodeToPhone, data: {"phone": phone});
      if (res.statusCode != 200) {
        throw ServerException( 'Не удалось отправить код', res.statusCode);
      }
    } catch (e) {
      log("$e");
      throw ServerException( 'Ошибка при отправке кода' , null);
    }
  }

  @override
  Future<void> refreshToken() async {
    log("refreshToken started...");
    try {
      final res = await _dio.post(
        ApiConst.refreshToken,
        data: {"refreshToken": _prefs.getString(AppConst.refreshToken)},
      );

      if (res.statusCode == 200) {
        await _localDataSource.setTokenToCache(
          refresh: res.data['refreshToken'],
          access: res.data['accessToken'],
        );
      } else {
        throw ServerException( 'Не удалось обновить токен', res.statusCode);
      }
    } catch (e) {
      log("$e");
      throw ServerException( 'Ошибка при обновлении токена', null);
    } finally {
      log("refreshToken finished...");
    }
  }
}
