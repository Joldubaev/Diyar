import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// Обёртка над [SignalRHttpClient], подменяющая схему wss/ws на https/http в URL запроса.
/// Библиотека signalr_netcore при редиректе от сервера может вызвать negotiate по wss:// URL,
/// из‑за чего стандартный HTTP-клиент падает с "Unsupported scheme 'wss'".
/// Эта обёртка переводит такие запросы на https/http перед отправкой.
class SignalRHttpClientWssFix extends SignalRHttpClient {
  SignalRHttpClientWssFix([Logger? logger])
      : _inner = WebSupportingHttpClient(logger);

  final SignalRHttpClient _inner;

  static String _fixUrl(String url) {
    if (url.startsWith('wss://')) {
      return url.replaceFirst('wss://', 'https://');
    }
    if (url.startsWith('ws://')) {
      return url.replaceFirst('ws://', 'http://');
    }
    return url;
  }

  @override
  Future<SignalRHttpResponse> send(SignalRHttpRequest request) {
    final url = request.url;
    if (url != null && (url.startsWith('wss://') || url.startsWith('ws://'))) {
      request = SignalRHttpRequest(
        method: request.method,
        url: _fixUrl(url),
        content: request.content,
        headers: request.headers,
        abortSignal: request.abortSignal,
        timeout: request.timeout,
      );
    }
    return _inner.send(request);
  }
}
