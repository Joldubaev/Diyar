import 'package:network/network.dart';
import 'package:storage/storage.dart';

import '../constants/app_const/app_const.dart';

/// App-specific [TokenStorage] implementation backed by [PreferencesStorage].
/// Uses [AppConst] keys for token persistence.
class AppTokenStorage implements TokenStorage {
  const AppTokenStorage(this._storage);

  final PreferencesStorage _storage;

  @override
  Future<String?> readAccessToken() =>
      _storage.read(AppConst.accessToken);

  @override
  Future<String?> readRefreshToken() =>
      _storage.read(AppConst.refreshToken);

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.save(AppConst.accessToken, accessToken),
      _storage.save(AppConst.refreshToken, refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(AppConst.accessToken),
      _storage.delete(AppConst.refreshToken),
    ]);
  }
}
