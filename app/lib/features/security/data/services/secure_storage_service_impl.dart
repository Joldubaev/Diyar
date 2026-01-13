import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:diyar/features/security/data/datasources/local/security_local_data_source.dart';
import 'package:diyar/features/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SecureStorageService)
class SecureStorageServiceImpl implements SecureStorageService {
  final SecurityLocalDataSource _securityLocalDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final LocalStorage _localStorage;

  SecureStorageServiceImpl(
    this._securityLocalDataSource,
    this._authLocalDataSource,
    this._localStorage,
  );

  @override
  Future<void> setPinCode(String code) async {
    return _securityLocalDataSource.setPinCode(code);
  }

  @override
  Future<String?> getPinCode() async {
    return _securityLocalDataSource.getPinCode();
  }

  @override
  Future<bool> isFirstLaunch() async {
    return _authLocalDataSource.isFirstLaunch();
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    return _authLocalDataSource.setFirstLaunchCompleted();
  }

  @override
  Future<void> setBiometricPreference(bool enabled) async {
    await _localStorage.setBool(AppConst.biometricPrefKey, enabled);
  }

  @override
  Future<bool> getBiometricPreference() async {
    return _localStorage.getBool(AppConst.biometricPrefKey) ?? false;
  }

  @override
  Future<String?> getAccessToken() async {
    return _localStorage.getString(AppConst.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _localStorage.getString(AppConst.refreshToken);
  }

  @override
  Future<String?> getUserRole() async {
    return _localStorage.getString(AppConst.userRole);
  }
}

