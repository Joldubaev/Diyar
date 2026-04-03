import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/user/profile/data/models/user_profile_model.dart';
import 'package:fpdart/fpdart.dart' show Either;

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileModel>> getUser();
  Future<Either<Failure, String>> updateUser(String name, String phone);
  Future<Either<Failure, String>> deleteUser();
}
