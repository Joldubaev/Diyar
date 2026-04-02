/// Generic SignalR client for Diyar.
///
/// Provides [HubManager] for managing SignalR connections with
/// automatic reconnection, subscription, and cleanup.
library signalr_client;

export 'src/hub_manager.dart';
export 'src/hub_connection_config.dart';
export 'src/signalr_wss_fix.dart';
