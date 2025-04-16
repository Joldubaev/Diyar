import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'app_logger.dart';
import '../../features/features.dart';
import '../../injection_container.dart';
import '../../shared/constants/api_const/api_const.dart';
import '../../shared/constants/app_const/app_const.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger_interceptor.dart';

class DioNetwork {
  static late Dio appAPI;
  static late Dio retryAPI;

  // Флаг и очередь для обработки обновления токена
  static bool isRefreshing = false;
  static List<Function> tokenRequestQueue = [];

  static void initDio() {
    appAPI = Dio(baseOptions(ApiConst.baseUrl));
    appAPI.interceptors.add(loggerInterceptor());
    appAPI.interceptors.add(appQueuedInterceptorsWrapper());

    retryAPI = Dio(baseOptions(ApiConst.baseUrl));
    retryAPI.interceptors.add(loggerInterceptor());
    retryAPI.interceptors.add(interceptorsWrapper());
  }

  static LoggerInterceptor loggerInterceptor() {
    return LoggerInterceptor(
      logger,
      request: true,
      requestBody: true,
      error: true,
      responseBody: true,
      responseHeader: false,
      requestHeader: true,
    );
  }

  ///__________App__________///

  /// App Api Queued Interceptor
  static QueuedInterceptorsWrapper appQueuedInterceptorsWrapper() {
    return QueuedInterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        String? token = sl<SharedPreferences>().getString(AppConst.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        if (kDebugMode) {
          print("Request Headers after adding access token:");
          print(json.encode(options.headers));
        }

        return handler.next(options); // Продолжаем выполнение запроса
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        var token = sl<SharedPreferences>().getString(AppConst.accessToken);
        bool isExpired = token != null && JwtDecoder.isExpired(token);
        if (error.response?.statusCode == 401 && isExpired) {
          // Если уже идет процесс обновления токена, ждем завершения
          if (!isRefreshing) {
            isRefreshing = true;
            try {
              // Пытаемся обновить токен
              await sl<AuthRepository>().refreshToken();

              // Получаем новый токен
              var newAccessToken =
                  sl<SharedPreferences>().getString(AppConst.accessToken);

              // Обрабатываем запросы, которые ждали обновления токена
              for (var callback in tokenRequestQueue) {
                callback();
              }
              tokenRequestQueue.clear();
              isRefreshing = false;

              // Если токен обновлен, повторяем оригинальный запрос
              if (newAccessToken != null) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final newRequest = await sl<Dio>().fetch(error.requestOptions);
                return handler
                    .resolve(newRequest); // Возвращаем обновленный ответ
              }
            } catch (e) {
              // Обработка ошибки при обновлении токена
              log("Error during token refresh: $e");
              isRefreshing = false;
              return handler.reject(error);
            }
          } else {
            // Если обновление уже идет, добавляем запрос в очередь
            return await _addToQueue(error.requestOptions, handler);
          }
        }

        // Если это не ошибка авторизации, передаем ошибку дальше
        return handler.next(error);
      },
      onResponse: (Response<dynamic> response,
          ResponseInterceptorHandler handler) async {
        // Просто продолжаем, если ответ успешный
        return handler.next(response);
      },
    );
  }

  // Функция для добавления запросов в очередь во время обновления токена
  static Future<void> _addToQueue(
      RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    final completer = Completer<void>();
    tokenRequestQueue.add(() async {
      var newAccessToken =
          sl<SharedPreferences>().getString(AppConst.accessToken);
      if (newAccessToken != null) {
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      }
      final newRequest = await sl<Dio>().fetch(requestOptions);
      handler.resolve(newRequest);
      completer.complete();
    });
    return completer.future;
  }

  /// App interceptor
  static InterceptorsWrapper interceptorsWrapper() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        String? token = sl<SharedPreferences>().getString(AppConst.accessToken);
        log("Token: $token", name: 'AccessToken');
        Map<String, dynamic> headers = {
          if (token != null) 'Authorization': 'Bearer $token'
        };

        options.headers.addAll(headers);

        if (kDebugMode) {
          print("Request Headers after adding custom headers:");
          print(json.encode(options.headers));
        }

        return r.next(options);
      },
      onResponse: (response, handler) async {
        if ("${(response.data["code"] ?? "0")}" != "0") {
          return handler.resolve(response);
        } else {
          return handler.next(response);
        }
      },
      onError: (error, handler) {
        try {
          return handler.next(error);
        } catch (e) {
          return handler.reject(error);
        }
      },
    );
  }

  static BaseOptions baseOptions(String url) {
    return BaseOptions(
      baseUrl: url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (s) {
        return s! < 300;
      },
      responseType: ResponseType.json,
    );
  }
}
