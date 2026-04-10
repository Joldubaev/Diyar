import 'package:fpdart/fpdart.dart' show Either;
import 'package:diyar/core/core.dart';
import 'package:diyar/features/user/profile/profile.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl with RepositoryErrorHandler implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfileModel>> getUser() {
    return makeRequest(() async {
      final result = await _remoteDataSource.getUser();
      return result.fold((l) => throw ServerException(l.toString(), null), (r) => r);
    });
  }

  @override
  Future<Either<Failure, String>> updateUser(String name, String phone) {
    return makeRequest(() async {
      final result = await _remoteDataSource.updateUser(name, phone);
      return result.fold((l) => throw ServerException(l.toString(), null), (r) => r);
    });
  }

  @override
  Future<Either<Failure, String>> deleteUser() {
    return makeRequest(() async {
      final result = await _remoteDataSource.deleteUser();
      return result.fold((l) => throw ServerException(l.toString(), null), (r) => r);
    });
  }
}
