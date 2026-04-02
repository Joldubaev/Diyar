import 'dart:async';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:network/src/token/token_storage.dart';

/// Dio interceptor that handles Bearer token injection and automatic
/// token refresh on 401/403 responses.
///
/// Uses a queue pattern: while a refresh is in progress, subsequent
/// failing requests are queued and retried after the refresh completes.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    this.refreshEndpoint = 'https://api.diyar.kg/api/v1/auth/refresh-token',
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  final TokenStorage _tokenStorage;
  final Dio _dio;
  final String refreshEndpoint;

  /// Optional external refresh callback. If set, used instead of the
  /// built-in HTTP refresh call.
  TokenRefreshCallback? tokenRefresher;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isAuthError = statusCode == 401 || statusCode == 403;
    final isRefreshRequest = err.requestOptions.path.contains('refresh');

    if (!isAuthError || isRefreshRequest) {
      return super.onError(err, handler);
    }

    // Queue this request
    final completer = Completer<Response<dynamic>>();
    _queue.add(_QueuedRequest(err.requestOptions, handler, completer));

    if (_isRefreshing) return;

    _isRefreshing = true;
    try {
      final newAccessToken = await _performRefresh();

      if (newAccessToken != null) {
        // Retry all queued requests with the new token
        for (final queued in List<_QueuedRequest>.from(_queue)) {
          queued.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          try {
            final response = await _dio.fetch(queued.requestOptions);
            queued.handler.resolve(response);
          } on DioException catch (e) {
            queued.handler.reject(e);
          }
        }
      } else {
        _rejectAll(err);
      }
    } catch (e) {
      dev.log('[AuthInterceptor] Refresh failed: $e');
      _rejectAll(err);
    } finally {
      _queue.clear();
      _isRefreshing = false;
    }
  }

  Future<String?> _performRefresh() async {
    // Prefer external callback (set by app-level DI binding)
    if (tokenRefresher != null) {
      return tokenRefresher!();
    }

    // Fallback: direct HTTP refresh
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    final response = await _dio.post(
      refreshEndpoint,
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final newAccess = data['accessToken'] as String;
      final newRefresh = data['refreshToken'] as String;
      await _tokenStorage.saveTokens(newAccess, newRefresh);
      return newAccess;
    }
    return null;
  }

  void _rejectAll(DioException original) {
    for (final queued in _queue) {
      queued.handler.reject(original);
    }
  }
}

class _QueuedRequest {
  _QueuedRequest(this.requestOptions, this.handler, this.completer);

  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
  final Completer<Response<dynamic>> completer;
}
