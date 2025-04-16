import '../../../features.dart';

abstract class AuthRepository {
  Future<void> login(UserModel user);
  Future<void> register(UserModel user);
  Future<void> sendForgotPasswordCodeToPhone(String phone);
  Future<void> resetPassword({required ResetModel model});
  Future<void> refreshToken();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<void> login(UserModel user) async {
    return _remoteDataSource.login(user);
  }

  @override
  Future<void> register(UserModel user) async {
    return _remoteDataSource.register(user);
  }

  @override
  Future<void> sendForgotPasswordCodeToPhone(String phone) async {
    return _remoteDataSource.sendForgotPasswordCodeToPhone(phone);
  }

  @override
  Future<void> resetPassword({required ResetModel model}) async {
    return _remoteDataSource.confirmResetPassword(model: model);
  }

  @override
  Future<void> logout() async => await _localDataSource.logout();

  @override
  Future<void> refreshToken() async => await _remoteDataSource.refreshToken();
}
