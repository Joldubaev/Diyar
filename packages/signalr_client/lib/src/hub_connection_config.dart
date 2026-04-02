/// Configuration for a SignalR hub connection.
class HubConnectionConfig {
  const HubConnectionConfig({
    required this.hubUrl,
    this.accessToken,
    this.autoReconnect = true,
    this.loggerName = 'SignalR',
  });

  /// The full URL of the SignalR hub endpoint.
  final String hubUrl;

  /// Optional JWT access token. If provided, appended as query parameter.
  final String? accessToken;

  /// Whether to enable automatic reconnection.
  final bool autoReconnect;

  /// Name for the logger instance.
  final String loggerName;

  /// Returns the hub URL with access_token query parameter if provided.
  String get effectiveUrl {
    if (accessToken == null || accessToken!.isEmpty) return hubUrl;
    return '$hubUrl?access_token=${Uri.encodeComponent(accessToken!)}';
  }
}
