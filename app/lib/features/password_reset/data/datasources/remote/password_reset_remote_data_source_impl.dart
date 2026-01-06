import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/password_reset/data/models/reset_password_model.dart';
import 'package:injectable/injectable.dart';
import 'package:rest_client/rest_client.dart' as rest_client;

import 'password_reset_remote_data_source.dart';

@LazySingleton(as: PasswordResetRemoteDataSource)
class PasswordResetRemoteDataSourceImpl implements PasswordResetRemoteDataSource {
  final rest_client.RestClient _restClient;

  PasswordResetRemoteDataSourceImpl(
    @Named('unauthRestClient') this._restClient,
  );

  Future<Either<Failure, Map<String, dynamic>>> _executePost({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _restClient.post<dynamic>(
        endpoint,
        body: data,
        params: queryParameters,
      );

      if (response is Map) {
        final normalizedData = _normalizeResponseData(response);
        // Проверяем код ответа, если есть
        if (normalizedData.containsKey('code') && normalizedData['code'] != 200 && normalizedData['code'] != 0) {
          return Left(_extractError(normalizedData));
        }
        return Right(normalizedData);
      }

      return Left(const FormatFailure('Неверный формат ответа сервера'));
    } on rest_client.ServerFailure catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on rest_client.NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    } on rest_client.AppFailure catch (e) {
      return Left(ServerFailure(e.message));
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
    log('[PASSWORD RESET ERROR] Unexpected error: $error');
    return ServerFailure('Неизвестная ошибка: ${error.toString()}');
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
}

