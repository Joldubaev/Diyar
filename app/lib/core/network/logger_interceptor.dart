import 'dart:developer';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class LoggerInterceptor extends Interceptor {
  LoggerInterceptor(
    this.logger, {
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
  });

  final Logger logger;

  bool request;
  bool requestHeader;
  bool requestBody;
  bool responseBody;
  bool responseHeader;
  bool error;

  final String divider = '────────────────────────────────────────';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logBlock(
      title: 'HTTP REQUEST',
      body: [
        _kv('URI', options.uri),
        if (request) ...[
          _kv('Method', options.method),
          _kv('ResponseType', options.responseType),
          _kv('FollowRedirects', options.followRedirects),
          _kv('ConnectTimeout', options.connectTimeout?.inMilliseconds ?? 0),
          _kv('ReceiveTimeout', options.receiveTimeout?.inMilliseconds ?? 0),
          _kv('Extra', options.extra),
        ],
        if (requestHeader) _headerToString(options.headers),
        if (requestBody && options.data != null)
          _bodyToString('Request Body', options.data),
      ],
    );

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (error) {
      _logBlock(
        title: '🚨 DIO ERROR',
        isError: true,
        body: [
          _kv('URI', err.requestOptions.uri),
          _kv('Message', err.message),
          if (err.response != null) ...[
            _kv('StatusCode', err.response?.statusCode),
            _headerToString(err.response!.headers.map),
            if (responseBody)
              _bodyToString('Error Response', err.response?.data),
          ],
        ],
      );
    }

    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _logBlock(
      title: 'HTTP RESPONSE',
      body: [
        _kv('URI', response.requestOptions.uri),
        if (responseHeader) ...[
          _kv('StatusCode', response.statusCode),
          if (response.isRedirect == true) _kv('Redirect', response.realUri),
          _headerToString(response.headers.map),
        ],
        if (responseBody) _bodyToString('Response Body', response.data),
      ],
    );

    return super.onResponse(response, handler);
  }

  void _logBlock({
    required String title,
    required List<String> body,
    bool isError = false,
  }) {
    final color = isError ? '\x1b[31m' : '\x1b[36m'; // red / cyan
    const end = '\x1b[0m';

    logPrint('');
    logPrint('$color$divider$end');
    logPrint('$color$title$end');
    logPrint('$color$divider$end');

    for (final line in body) {
      if (line.trim().isNotEmpty) logPrint(line);
    }

    logPrint('$color$divider$end\n');
  }

  String _kv(String key, Object? value) => '• $key: ${value ?? "null"}';

  String _headerToString(Map<String, dynamic> headers) {
    if (headers.isEmpty) return '• Headers: {}';

    final buffer = StringBuffer('• Headers:\n');
    headers.forEach((k, v) {
      buffer.writeln('   - $k: $v');
    });
    return buffer.toString();
  }

  String _bodyToString(String title, dynamic body) {
    final pretty = _tryPrettyJson(body);
    return '• $title:\n$pretty';
  }

  String _tryPrettyJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) { log('[logger_interceptor] $e');
      return data.toString();
    }
  }

  void logPrint(String text) => logger.info(text);
}
