import 'dart:async';

import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioNetwork {
  static late Dio appAPI;
  static late Dio retryAPI;

  // Single-flight refresh: пока идёт обновление токена,
  // все параллельные 401 ждут одного и того же Future.
  static Completer<void>? _refreshCompleter;

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
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        String? token = sl<SharedPreferences>().getString(AppConst.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        var token = sl<SharedPreferences>().getString(AppConst.accessToken);
        bool isExpired = token != null && JwtDecoder.isExpired(token);
        if (error.response?.statusCode == 401 && isExpired) {
          // Single-flight: если refresh уже идёт, ждём его завершения
          if (_refreshCompleter != null) {
            await _refreshCompleter!.future.catchError((_) {});
          } else {
            _refreshCompleter = Completer<void>();
            try {
              await sl<AuthRepository>().refreshToken();
              _refreshCompleter!.complete();
            } catch (e) {
              _refreshCompleter!.completeError(e);
              _refreshCompleter = null;
              return handler.reject(error);
            }
            _refreshCompleter = null;
          }

          // Повторяем оригинальный запрос с новым токеном
          final newToken = sl<SharedPreferences>().getString(AppConst.accessToken);
          if (newToken != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final newRequest = await sl<Dio>().fetch(error.requestOptions);
            return handler.resolve(newRequest);
          }
        }

        return handler.next(error);
      },
      onResponse: (Response<dynamic> response, ResponseInterceptorHandler handler) async {
        return handler.next(response);
      },
    );
  }

  /// App interceptor
  static InterceptorsWrapper interceptorsWrapper() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, r) async {
        String? token = sl<SharedPreferences>().getString(AppConst.accessToken);
        Map<String, dynamic> headers = {if (token != null) 'Authorization': 'Bearer $token'};

        options.headers.addAll(headers);
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
      validateStatus: (s) => s != null && s < 300,
      responseType: ResponseType.json,
    );
  }
}
