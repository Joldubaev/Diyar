import 'dart:async';
import 'dart:developer' as dev;

import 'package:logging/logging.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';

import 'hub_connection_config.dart';
import 'signalr_wss_fix.dart';

/// Generic SignalR hub manager that handles connection lifecycle.
///
/// Replaces the 3 duplicated SignalR services (OrderStatus,
/// CourierLocation, PaymentStatus) with a single reusable component.
/// Pass [onReconnected] to re-invoke Subscribe/RequestStatus after automatic reconnect.
///
/// Usage:
/// ```dart
/// final hub = HubManager(config: HubConnectionConfig(hubUrl: '...'));
/// hub.on('ReceiveStatus', (data) { ... });
/// await hub.start();
/// await hub.invoke('Subscribe', args: [userId]);
/// await hub.stop();
/// ```
class HubManager {
  HubManager({
    required this.config,
    this.onReconnected,
    this.onClosed,
  });

  final HubConnectionConfig config;

  /// Вызывается после automatic reconnect (снова Subscribe / RequestStatus на сервере).
  final Future<void> Function()? onReconnected;

  /// Вызывается когда соединение окончательно закрыто (реконнекты исчерпаны или stop).
  final void Function()? onClosed;

  HubConnection? _connection;
  final Map<String, void Function(List<Object?>?)> _handlers = {};
  bool _disposed = false;

  /// Whether the connection is currently active.
  bool get isConnected =>
      _connection?.state == HubConnectionState.Connected;

  /// Register a handler for a hub method. Must be called before [start].
  void on(String methodName, void Function(List<Object?>? args) handler) {
    _handlers[methodName] = handler;
  }

  /// Connect to the hub and register all handlers.
  Future<void> start() async {
    if (_disposed) return;
    if (_connection != null) return;

    try {
      final logger = Logger(config.loggerName)..level = Level.ALL;
      final builder = HubConnectionBuilder()
          .withUrl(
            config.effectiveUrl,
            options: HttpConnectionOptions(
              httpClient: SignalRHttpClientWssFix(logger),
              skipNegotiation: config.skipNegotiation,
              transport: config.skipNegotiation ? HttpTransportType.WebSockets : null,
            ),
          )
          .configureLogging(logger);

      if (config.autoReconnect) {
        final intervals = config.reconnectIntervals;
        if (intervals != null) {
          builder.withAutomaticReconnect(retryDelays: intervals);
        } else {
          builder.withAutomaticReconnect();
        }
      }

      _connection = builder.build();

      // Register all handlers
      for (final entry in _handlers.entries) {
        _connection!.on(entry.key, entry.value);
      }

      _connection!.onclose(({error}) {
        dev.log('[${config.loggerName}] Connection closed: $error');
        onClosed?.call();
      });

      _connection!.onreconnected(({connectionId}) {
        dev.log('[${config.loggerName}] Reconnected: $connectionId');
        final cb = onReconnected;
        if (cb != null) {
          unawaited(
            Future(() async {
              try {
                await cb();
              } catch (e, st) {
                dev.log('[${config.loggerName}] onReconnected error: $e\n$st');
              }
            }),
          );
        }
      });

      await _connection!.start();
      dev.log('[${config.loggerName}] Connected to ${config.hubUrl}');
    } catch (e) {
      dev.log('[${config.loggerName}] Start error: $e');
      _connection = null;
      rethrow;
    }
  }

  /// Invoke a hub method with optional arguments.
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    if (_connection == null) return null;
    try {
      return await _connection!.invoke(methodName, args: args ?? []);
    } catch (e) {
      dev.log('[${config.loggerName}] Invoke "$methodName" error: $e');
      rethrow;
    }
  }

  /// Stop the connection and clean up.
  Future<void> stop() async {
    try {
      await _connection?.stop();
    } catch (e) {
      dev.log('[${config.loggerName}] Stop error: $e');
    } finally {
      _connection = null;
    }
  }

  /// Permanently dispose the manager.
  Future<void> dispose() async {
    _disposed = true;
    await stop();
    _handlers.clear();
  }
}
