import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// [LocaleInterceptor] - это перехватчик для Dio, который добавляет
/// информацию о текущей локали (языке) пользователя в каждый сетевой запрос.
/// Он использует [ValueGetter<String>] для получения кода языка
/// (например, "en", "ru") и добавляет его в заголовок 'Content-Language'.
/// Это позволяет серверу возвращать контент на соответствующем языке.
class LocaleInterceptor extends QueuedInterceptor {
  LocaleInterceptor({required this.localeGetter});

  final ValueGetter<String> localeGetter;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'Content-Language': localeGetter()});
    super.onRequest(options, handler);
  }
}
