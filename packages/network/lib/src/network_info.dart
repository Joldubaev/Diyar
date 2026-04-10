import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks whether the device has an active internet connection.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
