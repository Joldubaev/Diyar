import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/profile/profile.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileModel>> getUser();
  Future<Either<Failure, String>> updateUser(String name, String phone);
  Future<Either<Failure, String>> deleteUser();
}

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfileModel>> getUser() async {
    try {
      return await _remoteDataSource.getUser();
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser(String name, String phone) async {
    try {
      return await _remoteDataSource.updateUser(name, phone);
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }

  @override
  Future<Either<Failure, String>> deleteUser() async {
    try {
      return await _remoteDataSource.deleteUser();
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
