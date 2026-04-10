import 'package:dio/dio.dart';

/// Adds `Content-Language` header to every outgoing request.
class LocaleInterceptor extends QueuedInterceptor {
  LocaleInterceptor({required this.localeGetter});

  final String Function() localeGetter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Content-Language'] = localeGetter();
    super.onRequest(options, handler);
  }
}
