import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/data/models/reset_password_model.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, void>> login(UserModel user);
  Future<Either<Failure, void>> register(UserModel user);
  Future<Either<Failure, bool>> checkPhoneNumber(String phone);
  Future<Either<Failure, void>> sendVerificationCode(String phone);
  Future<Either<Failure, void>> verifyCode(String phone, String code);
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model);
  Future<Either<Failure, void>> refreshToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSource _localDataSource;
  final SharedPreferences _prefs;
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio, this._localDataSource, this._prefs);

  // ───── LOGIN ─────
  @override
  Future<Either<Failure, void>> login(UserModel user) async {
    try {
      final res = await _dio.post(ApiConst.signIn, data: user.toLogin());

      final data = res.data;
      final message = data['message'];

      if (data['code'] == 200 && message is Map) {
        final accessToken = message['accessToken'];
        final refreshToken = message['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          log('[LOGIN] accessToken: $accessToken');
          log('[LOGIN] refreshToken: $refreshToken');

          await _localDataSource.setTokenToCache(
            refresh: refreshToken,
            access: accessToken,
            phone: user.phone,
          );

          log('[LOGIN] Токены успешно сохранены в кэш');
          return const Right(null);
        } else {
          return const Left(Failure('accessToken или refreshToken отсутствуют'));
        }
      } else {
        return const Left(Failure('Некорректный ответ от сервера'));
      }
    } catch (e) {
      log("login error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> register(UserModel user) async {
    try {
      final res = await _dio.post(ApiConst.signUp, data: user.toRegister());

      if ([200, 201].contains(res.data['code'])) {
        return await login(user); // авторизация после регистрации
      } else {
        return Left(Failure(res.data['message'].toString()));
      }
    } catch (e) {
      log("register error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phone) async {
    try {
      final res = await _dio.post(
        ApiConst.checkPhone,
        queryParameters: {"phoneNumber": phone},
      );
      log("checkPhoneNumber: ${res.data}");

      if (res.statusCode == 200) {
        return Right(res.data['exists'] ?? false);
      } else {
        return Left(Failure(res.data['message'].toString()));
      }
    } catch (e) {
      log("checkPhoneNumber error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(String phone, String code) async {
    try {
      final res = await _dio.post(
        ApiConst.verifyCode,
        data: {"phoneNumber": phone, "verifyCode": code},
      );

      if (res.statusCode == 200) {
        if (res.data['refreshToken'] != null && res.data['accessToken'] != null) {
          await _localDataSource.setTokenToCache(
            refresh: res.data['refreshToken'],
            access: res.data['accessToken'],
          );
        }
        return const Right(null);
      } else {
        return Left(Failure(res.data['message'].toString()));
      }
    } catch (e) {
      log("verifyCode error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(String phone) async {
    try {
      final res = await _dio.post(
        ApiConst.sendCode,
        data: {"phone": phone},
      );

      return res.statusCode == 200 ? const Right(null) : Left(Failure(res.data['message'].toString()));
    } catch (e) {
      log("sendVerificationCode error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone) async {
    try {
      final res = await _dio.post(
        ApiConst.sendCodeToPhone,
        data: {"phone": phone},
      );

      return res.statusCode == 200 ? const Right(null) : Left(Failure(res.data['message'].toString()));
    } catch (e) {
      log("sendForgotPasswordCodeToPhone error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model) async {
    try {
      final res = await _dio.post(
        ApiConst.resetPsw,
        data: model.toJson(),
      );

      return res.statusCode == 200 ? const Right(null) : Left(Failure(res.data['message'].toString()));
    } catch (e) {
      log("confirmResetPassword error: $e");
      return _extractDioError(e);
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final currentRefreshToken =
          _prefs.getString(AppConst.refreshToken); // Можно заменить на метод из _localDataSource, если он есть
      if (currentRefreshToken == null) {
        log("[Refresh Token] No refresh token found in prefs. Cannot refresh.");
        return const Left(Failure("Refresh token не найден"));
      }

      log("[Refresh Token] Attempting to refresh with token: $currentRefreshToken");
      final res = await _dio.post(
        ApiConst.refreshToken,
        data: {"refreshToken": currentRefreshToken},
      );

      final data = res.data; // Для удобства
      log("[Refresh Token] Response status: ${res.statusCode}");
      log("[Refresh Token] Response data: $data");

      if (res.statusCode == 200 && data is Map && data['code'] == 200 && data['message'] is Map) {
        final messageData = data['message'] as Map;
        final String? newAccessToken = messageData['accessToken'] as String?;
        // final String? newRefreshToken = messageData['refreshToken'] as String?; // Удаляем ожидание нового refreshToken

        if (newAccessToken != null) {
          // Убедимся, что новый accessToken есть и старый refreshToken тоже
          log('[Refresh Token] New Access Token: $newAccessToken');
          log('[Refresh Token] Keeping Old Refresh Token: $currentRefreshToken'); // Добавим лог для ясности
          await _localDataSource.setTokenToCache(
            refresh: currentRefreshToken, // Используем старый refreshToken
            access: newAccessToken,
            // Телефон здесь не обновляем, так как это только обновление токена
          );
          log('[Refresh Token] Tokens successfully refreshed and saved.');
          return const Right(null);
        } else {
          log('[Refresh Token] Failed: New accessToken is null or original refreshToken was missing.'); // Обновляем сообщение об ошибке
          return const Left(Failure(
              "Не удалось получить новый accessToken из ответа сервера или отсутствовал исходный refreshToken"));
        }
      } else {
        String errorMessage = "Ошибка обновления токена";
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'].toString();
        } else if (res.statusMessage != null && res.statusMessage!.isNotEmpty) {
          errorMessage = res.statusMessage!;
        }
        log('[Refresh Token] Failed: Status code ${res.statusCode} or invalid response structure. Message: $errorMessage');
        return Left(Failure(errorMessage));
      }
    } catch (e) {
      log("[Refresh Token] Exception: $e");
      return _extractDioError(e);
    }
  }

  // ───── UNIVERSAL ERROR HANDLER ─────
  Either<Failure, T> _extractDioError<T>(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      String message = 'Произошла ошибка';

      if (data is Map && data['message'] is Map && data['message']['message'] is String) {
        message = data['message']['message'];
      } else if (data is Map && data['message'] is String) {
        message = data['message'];
      }

      return Left(Failure(message));
    } else if (e is CacheException) {
      return const Left(Failure("Ошибка при работе с кэшем"));
    } else {
      return const Left(Failure("Неизвестная ошибка"));
    }
  }
}
