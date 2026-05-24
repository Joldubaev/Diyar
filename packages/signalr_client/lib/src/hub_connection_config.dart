/// Configuration for a SignalR hub connection.
class HubConnectionConfig {
  const HubConnectionConfig({
    required this.hubUrl,
    this.accessToken,
    this.autoReconnect = true,
    this.skipNegotiation = false,
    this.reconnectIntervals,
    this.loggerName = 'SignalR',
  });

  /// The full URL of the SignalR hub endpoint.
  final String hubUrl;

  /// Optional JWT access token. If provided, appended as query parameter.
  final String? accessToken;

  /// Whether to enable automatic reconnection.
  final bool autoReconnect;

  /// Skip the negotiate step and connect directly via WebSockets.
  /// Requires the server to support WebSocket-only transport.
  /// When true, [transport] is forced to WebSockets.
  final bool skipNegotiation;

  /// Custom reconnect delay intervals in milliseconds.
  /// Passed to [withAutomaticReconnect] retryDelays when [autoReconnect] is true.
  final List<int>? reconnectIntervals;

  /// Name for the logger instance.
  final String loggerName;

  /// Returns the hub URL with access_token query parameter if provided.
  String get effectiveUrl {
    if (accessToken == null || accessToken!.isEmpty) return hubUrl;
    return '$hubUrl?access_token=${Uri.encodeComponent(accessToken!)}';
  }
}
