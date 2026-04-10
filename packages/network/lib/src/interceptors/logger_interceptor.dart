import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Pretty-prints HTTP requests, responses, and errors.
class LoggerInterceptor extends Interceptor {
  LoggerInterceptor(
    this._logger, {
    this.logRequest = true,
    this.logRequestHeader = true,
    this.logRequestBody = false,
    this.logResponseHeader = true,
    this.logResponseBody = false,
    this.logError = true,
  });

  final Logger _logger;
  final bool logRequest;
  final bool logRequestHeader;
  final bool logRequestBody;
  final bool logResponseHeader;
  final bool logResponseBody;
  final bool logError;

  static const _divider = '────────────────────────────────────────';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logBlock(
      title: 'HTTP REQUEST',
      lines: [
        _kv('URI', options.uri),
        if (logRequest) ...[
          _kv('Method', options.method),
          _kv('ResponseType', options.responseType),
        ],
        if (logRequestHeader) _headers(options.headers),
        if (logRequestBody && options.data != null)
          _body('Request Body', options.data),
      ],
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logBlock(
      title: 'HTTP RESPONSE',
      lines: [
        _kv('URI', response.requestOptions.uri),
        if (logResponseHeader) _kv('StatusCode', response.statusCode),
        if (logResponseHeader) _headers(response.headers.map),
        if (logResponseBody) _body('Response Body', response.data),
      ],
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      _logBlock(
        title: 'DIO ERROR',
        isError: true,
        lines: [
          _kv('URI', err.requestOptions.uri),
          _kv('Message', err.message),
          if (err.response != null) _kv('StatusCode', err.response?.statusCode),
          if (logResponseBody && err.response != null)
            _body('Error Response', err.response?.data),
        ],
      );
    }
    super.onError(err, handler);
  }

  // -- Helpers ---------------------------------------------------------------

  void _logBlock({
    required String title,
    required List<String> lines,
    bool isError = false,
  }) {
    final color = isError ? '\x1b[31m' : '\x1b[36m';
    const end = '\x1b[0m';
    _log('$color$_divider$end');
    _log('$color$title$end');
    for (final line in lines) {
      if (line.trim().isNotEmpty) _log(line);
    }
    _log('$color$_divider$end');
  }

  String _kv(String key, Object? value) => '  $key: ${value ?? "null"}';

  String _headers(Map<String, dynamic> headers) {
    if (headers.isEmpty) return '  Headers: {}';
    final buf = StringBuffer('  Headers:\n');
    headers.forEach((k, v) => buf.writeln('    $k: $v'));
    return buf.toString();
  }

  String _body(String title, dynamic body) {
    try {
      final pretty = const JsonEncoder.withIndent('  ').convert(body);
      return '  $title:\n$pretty';
    } catch (_) {
      return '  $title: $body';
    }
  }

  void _log(String text) => _logger.info(text);
}
