import 'package:diyar/features/features.dart';

abstract class AuthRepository {
  // Future<void> confirmEmail(String email, int code);
  // Future<void> confirmResetPassword({
  //   required String email,
  //   required String otpCode,
  //   required String newPassword,
  // });
  Future<void> login(UserModel user);
  Future<void> register(UserModel user);
  Future<void> sendForgotPasswordCodeToEmail(String email);
  Future<void> resetPassword({required ResetModel model});
  Future<void> refreshToken();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  // @override
  // Future<void> confirmEmail(String email, int code) async {
  //   return _remoteDataSource.confirmEmail(email, code);
  // }

  // @override
  // Future<void> confirmResetPassword({
  //   required String email,
  //   required String otpCode,
  //   required String newPassword,
  // }) async {
  //   return _remoteDataSource.confirmResetPassword(
  //     email: email,
  //     otpCode: otpCode,
  //     newPassword: newPassword,
  //   );
  // }

  @override
  Future<void> login(UserModel user) async {
    return _remoteDataSource.login(user);
  }

  @override
  Future<void> register(UserModel user) async {
    return _remoteDataSource.register(user);
  }

  @override
  Future<void> sendForgotPasswordCodeToEmail(String email) async {
    return _remoteDataSource.sendForgotPasswordCodeToEmail(email);
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
