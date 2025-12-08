import 'dart:async';

import 'package:dio/dio.dart';

/// [AuthInterceptor] - это перехватчик для Dio, который автоматически
/// добавляет токен аутентификации к каждому исходящему сетевому запросу.
/// Он использует функцию [TokenGetter] для асинхронного получения токена,
/// что позволяет извлекать его, например, из защищенного хранилища.
/// Если токен доступен, он добавляется в заголовок 'Authorization'
/// с префиксом 'Bearer'.

typedef TokenGetter = Future<String?> Function();
typedef RefreshTokenGetter = Future<String?> Function();
typedef TokenSaver = Future<void> Function(
    String accessToken, String refreshToken);

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenGetter tokenGetter,
    required RefreshTokenGetter refreshTokenGetter,
    required TokenSaver tokenSaver,
    required Dio dio,
  })  : _tokenGetter = tokenGetter,
        _refreshTokenGetter = refreshTokenGetter,
        _tokenSaver = tokenSaver,
        _dio = dio;

  final TokenGetter _tokenGetter;
  final RefreshTokenGetter _refreshTokenGetter;
  final TokenSaver _tokenSaver;
  final Dio _dio;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = [];

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _tokenGetter();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Только 401 и 403, кроме refresh endpoint
    if ((err.response?.statusCode == 401 || err.response?.statusCode == 403) &&
        !err.requestOptions.path.contains(
            'http://10.145.90.119:8080/api/v1/Accounts/RefreshToken?')) {
      final refreshToken = await _refreshTokenGetter();

      if (refreshToken == null || refreshToken.isEmpty) {
        return handler.next(err);
      }

      final requestOptions = err.requestOptions;

      // Если уже идет обновление токена, добавляем в очередь
      final completer = Completer<Response>();
      _queue.add(_QueuedRequest(requestOptions, handler, completer));

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final response = await _dio.post(
            'https://api.diyar.kg/api/v1/auth/refresh-token$refreshToken',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['accessToken'] as String;
            final newRefreshToken = response.data['refreshToken'] as String;

            // Сохраняем новые токены
            await _tokenSaver(newAccessToken, newRefreshToken);

            // Повторяем все отложенные запросы
            for (final queued in List<_QueuedRequest>.from(_queue)) {
              queued.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              try {
                final r = await _dio.fetch(queued.requestOptions);
                queued.handler.resolve(r);
              } catch (e) {
                queued.handler.reject(e as DioException);
              }
            }
            _queue.clear();
          } else {
            // Если обновление не удалось
            for (final queued in _queue) {
              queued.handler.reject(err);
            }
            _queue.clear();
          }
        } catch (e) {
          for (final queued in _queue) {
            queued.handler.reject(err);
          }
          _queue.clear();
        } finally {
          _isRefreshing = false;
        }
      }
      return;
    }

    super.onError(err, handler);
  }
}

class _QueuedRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
  final Completer<Response> completer;

  _QueuedRequest(this.requestOptions, this.handler, this.completer);
}
