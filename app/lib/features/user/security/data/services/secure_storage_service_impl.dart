import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:diyar/features/user/security/domain/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:storage/storage.dart';

@LazySingleton(as: SecureStorageService)
class SecureStorageServiceImpl implements SecureStorageService {
  final AuthLocalDataSource _authLocalDataSource;
  final LocalStorage _localStorage;
  final SecureStorage _secureStorage;

  SecureStorageServiceImpl(
    this._authLocalDataSource,
    this._localStorage,
    this._secureStorage,
  );

  @override
  Future<bool> isFirstLaunch() async {
    return _authLocalDataSource.isFirstLaunch();
  }

  @override
  Future<void> setFirstLaunchCompleted() async {
    return _authLocalDataSource.setFirstLaunchCompleted();
  }

  @override
  Future<String?> getAccessToken() async {
    return _secureStorage.read(AppConst.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(AppConst.refreshToken);
  }

  @override
  Future<String?> getUserRole() async {
    return _localStorage.getString(AppConst.userRole);
  }
}
