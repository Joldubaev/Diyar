import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/data/models/reset_password_model.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  // 🔓 Login
  Future<Either<Failure, void>> login(UserModel user);

  // 🔐 Registration
  Future<Either<Failure, void>> register(UserModel user);
  Future<Either<Failure, bool>> checkPhoneNumber(String phone);
  Future<Either<Failure, void>> sendVerificationCode(String phone);
  Future<Either<Failure, void>> verifyCode(String phone, String code);

  // 🔄 Password
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone);
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model);

  // 🔁 Tokens
  Future<Either<Failure, void>> refreshToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSource _localDataSource;
  final SharedPreferences _prefs;
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio, this._localDataSource, this._prefs);

  Failure _handleError(dynamic e) {
    if (e is DioException) {
      final msg = e.response?.data['message'] ?? e.message ?? 'Неизвестная ошибка';
      return Failure(msg.toString());
    }
    return const Failure('Непредвиденная ошибка');
  }

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

      if (e is DioException) {
        return Left(Failure(handleDioError(e)));
      } else if (e is CacheException) {
        return const Left(Failure("Ошибка при сохранении токенов в кэш"));
      } else {
        return const Left(Failure("Неизвестная ошибка при логине"));
      }
    }
  }

  // ───── REGISTER ─────
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
      return Left(_handleError(e));
    }
  }

  // ───── PHONE CHECK ─────
  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phone) async {
    try {
      final res = await _dio.post(
        ApiConst.checkPhone,
        queryParameters: {"phoneNumber": phone},
      );
      log("checkPhoneNumber: ${res.data}");

      if (res.statusCode == 200) {
        // await _localDataSource.setToUserPhine(phone);
        return Right(res.data['exists'] ?? false);
      } else {
        return Left(Failure(res.data['message'].toString()));
      }
    } catch (e) {
      log("checkPhoneNumber error: $e");
      return Left(_handleError(e));
    }
  }

  // ───── VERIFY CODE ─────
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
      return Left(_handleError(e));
    }
  }

  // ───── SEND CODE ─────
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
      return Left(_handleError(e));
    }
  }

  // ───── RESET CODE ─────
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
      return Left(_handleError(e));
    }
  }

  // ───── CONFIRM RESET ─────
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
      return Left(_handleError(e));
    }
  }

  // ───── REFRESH TOKEN ─────
  @override
  Future<Either<Failure, void>> refreshToken() async {
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
        return const Right(null);
      } else {
        return Left(Failure(res.data['message'].toString()));
      }
    } catch (e) {
      log("refreshToken error: $e");
      return Left(_handleError(e));
    }
  }
}
