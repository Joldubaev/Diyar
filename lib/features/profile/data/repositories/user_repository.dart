import 'package:diyar/features/auth/data/models/user_mpdel.dart';

import '../datasources/user_remote_data_source.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
  Future<void> updateEmail();
  Future<void> updatePhone();
  Future<void> updateUser(String name, String phone);
  Future<void> deleteUser();
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserModel> getUser() async {
    return _remoteDataSource.getUser();
  }

  @override
  Future<void> updateEmail() async {
    return _remoteDataSource.updateEmail();
  }

  @override
  Future<void> updatePhone() async {
    return _remoteDataSource.updatePhone();
  }

  @override
  Future<void> updateUser(name, phone) async {
    return _remoteDataSource.updateUser(name, phone);
  }

  @override
  Future<void> deleteUser() async {
    return _remoteDataSource.deleteUser();
  }
}
