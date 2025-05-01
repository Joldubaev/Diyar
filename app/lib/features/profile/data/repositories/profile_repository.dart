import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/features/profile/prof.dart';

abstract class ProfileRepository {
  Future<UserModel> getUser();
  Future<void> updateUser(String name, String phone);
  Future<void> deleteUser();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserModel> getUser() async {
    return _remoteDataSource.getUser();
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
