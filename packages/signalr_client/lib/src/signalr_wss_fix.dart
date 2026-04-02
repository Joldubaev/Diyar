import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// Wraps the default SignalR HTTP client to fix wss:// scheme issues.
///
/// The signalr_netcore library may call negotiate with a wss:// URL
/// after a server redirect, causing "Unsupported scheme 'wss'" errors.
/// This wrapper converts wss:// to https:// before sending.
class SignalRHttpClientWssFix extends SignalRHttpClient {
  SignalRHttpClientWssFix([Logger? logger])
      : _inner = WebSupportingHttpClient(logger);

  final SignalRHttpClient _inner;

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

  static String _fixUrl(String url) {
    if (url.startsWith('wss://')) return url.replaceFirst('wss://', 'https://');
    if (url.startsWith('ws://')) return url.replaceFirst('ws://', 'http://');
    return url;
  }
}
