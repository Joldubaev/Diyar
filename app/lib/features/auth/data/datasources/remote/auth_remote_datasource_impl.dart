import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:diyar/features/auth/data/models/reset_password_model.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

import 'auth_remote_data_source.dart';

class _Tokens {
  final String accessToken;
  final String refreshToken;

  _Tokens({required this.accessToken, required this.refreshToken});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final AuthLocalDataSource _localDataSource;
  final LocalStorage _localStorage;

  AuthRemoteDataSourceImpl(
    this._dio,
    this._localDataSource,
    this._localStorage,
  );

  Future<Either<Failure, Map<String, dynamic>>> _executePost({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200) {
        return Left(_extractError(response.data));
      }

      return Right(_normalizeResponseData(response.data));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Map<String, dynamic> _normalizeResponseData(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return <String, dynamic>{};
  }

  _Tokens? _extractTokens(Map<String, dynamic> data) {
    String? accessToken = data['accessToken'] as String?;
    String? refreshToken = data['refreshToken'] as String?;

    if (accessToken != null && refreshToken != null) {
      return _Tokens(accessToken: accessToken, refreshToken: refreshToken);
    }

    final message = data['message'];
    if (message is Map<String, dynamic>) {
      accessToken = message['accessToken'] as String?;
      refreshToken = message['refreshToken'] as String?;

      if (accessToken != null && refreshToken != null) {
        return _Tokens(accessToken: accessToken, refreshToken: refreshToken);
      }
    } else if (message is String) {
      accessToken = data['token'] as String? ?? data['access_token'] as String?;
      refreshToken = data['refresh_token'] as String?;

      if (accessToken != null && refreshToken != null) {
        return _Tokens(accessToken: accessToken, refreshToken: refreshToken);
      }
    }

    return null;
  }

  Failure _extractError(dynamic data) {
    final normalizedData = _normalizeResponseData(data);
    final message = normalizedData['message'];

    if (message is String && message.isNotEmpty) {
      return ServerFailure(message);
    } else if (message is Map) {
      final nestedMessage = message['message'];
      if (nestedMessage is String && nestedMessage.isNotEmpty) {
        return ServerFailure(nestedMessage);
      }
    }

    return const ServerFailure('Произошла ошибка на сервере');
  }

  Failure _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        return _extractError(error.response!.data);
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkFailure('Превышено время ожидания запроса');
        case DioExceptionType.connectionError:
          return const NetworkFailure('Ошибка соединения');
        case DioExceptionType.cancel:
          return const NetworkFailure('Запрос был отменен');
        case DioExceptionType.badResponse:
          return const ServerFailure('Ошибка сервера');
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          return NetworkFailure('Ошибка сети: ${error.message ?? 'Неизвестная сетевая ошибка'}');
      }
    }

    log('[AUTH ERROR] Unexpected error: $error');
    return ServerFailure('Неизвестная ошибка: ${error.toString()}');
  }

  @override
  Future<Either<Failure, void>> register(UserModel user) async {
    final result = await _executePost(
      endpoint: ApiConst.signUp,
      data: user.toRegister(),
    );

    return result.fold(
      Left.new,
      (data) async {
        final tokens = _extractTokens(data);

        if (tokens != null) {
          await _localDataSource.setTokenToCache(
            refresh: tokens.refreshToken,
            access: tokens.accessToken,
            phone: user.phone ?? '',
          );
        }

        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> checkPhoneNumber(String phone) async {
    final result = await _executePost(
      endpoint: ApiConst.checkPhone,
      queryParameters: {'phoneNumber': phone},
    );

    return result.fold(
      Left.new,
      (data) {
        final exists = (data['exists'] as bool?) ?? false;
        return Right(exists);
      },
    );
  }

  @override
  Future<Either<Failure, void>> verifyCodeForLogin(String phone, String code) async {
    final result = await _executePost(
      endpoint: ApiConst.verifyLogin,
      data: {'phoneNumber': phone, 'verifyCode': code},
    );

    return result.fold(
      Left.new,
      (data) async {
        final tokens = _extractTokens(data);

        if (tokens == null) {
          return const Left(FormatFailure('Токены не найдены в ответе сервера'));
        }

        await _localDataSource.setTokenToCache(
          refresh: tokens.refreshToken,
          access: tokens.accessToken,
          phone: phone,
        );

        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> verifyCodeForRegistration(String phone, String code) async {
    final result = await _executePost(
      endpoint: ApiConst.verifyRegister,
      data: {'phoneNumber': phone, 'verifyCode': code},
    );

    return result.fold(
      Left.new,
      (data) async {
        final tokens = _extractTokens(data);

        if (tokens != null) {
          await _localDataSource.setTokenToCache(
            refresh: tokens.refreshToken,
            access: tokens.accessToken,
            phone: phone,
          );
        }

        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(String phone) async {
    final result = await _executePost(
      endpoint: ApiConst.sendCode,
      data: {'phone': phone},
    );

    return result.fold(Left.new, (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> sendForgotPasswordCodeToPhone(String phone) async {
    final result = await _executePost(
      endpoint: ApiConst.sendCodeToPhone,
      data: {'phone': phone},
    );

    return result.fold(Left.new, (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> confirmResetPassword(ResetPasswordModel model) async {
    final result = await _executePost(
      endpoint: ApiConst.resetPsw,
      data: model.toJson(),
    );

    return result.fold(Left.new, (_) => const Right(null));
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    final refreshToken = _localStorage.getString(AppConst.refreshToken);
    if (refreshToken == null) {
      return const Left(CacheFailure('Refresh token не найден'));
    }

    final result = await _executePost(
      endpoint: ApiConst.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    return result.fold(
      Left.new,
      (data) async {
        String? newAccessToken = data['accessToken'] as String?;

        final messageData = data['message'];
        if (newAccessToken == null && messageData is Map) {
          newAccessToken = messageData['accessToken'] as String?;
        }

        if (newAccessToken == null) {
          return const Left(FormatFailure('Не удалось получить новый accessToken'));
        }

        await _localDataSource.setTokenToCache(
          refresh: refreshToken,
          access: newAccessToken,
          phone: '',
        );

        return const Right(null);
      },
    );
  }
}
