import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:injectable/injectable.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserProfileModel>> getUser();
  Future<Either<Failure, String>> updateUser(String name, String phone);
  Future<Either<Failure, String>> deleteUser();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;
  final LocalStorage _prefs;

  ProfileRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<Either<Failure, UserProfileModel>> getUser() async {
    try {
      log('get user phone: ${_prefs.getString(AppConst.phone)}');

      final res = await _dio.post(
        ApiConst.getUser,
        data: {"phone": _prefs.getString(AppConst.phone)},
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      if (res.statusCode == 200) {
        final json = res.data['message'];
        log('[GET USER] message: $json');
        return Right(UserProfileModel.fromJson(json));
      } else {
        return Left(ServerFailure('Error fetching user data', res.statusCode));
      }
    } catch (e) {
      log('[GET USER ERROR] $e');
      return Left(ServerFailure('Error fetching user data', null));
    }
  }

  @override
  Future<Either<Failure, String>> deleteUser() async {
    try {
      final token = _prefs.getString(AppConst.accessToken);
      var res = await _dio.delete(
        ApiConst.deleteUser,
        options: Options(headers: ApiConst.authMap(token ?? '')),
      );

      if (res.data['code'] == 200) {
        return Right(res.data['message']);
      } else {
        return Left(ServerFailure(
          'Error deleting user',
          res.statusCode,
        ));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          log('Error: User not found (404). $e');
          return Left(ServerFailure('User not found.', e.response!.statusCode));
        } else {
          log('Error: ${e.response!.statusCode} - ${e.response!.statusMessage}');
          return Left(ServerFailure('Server error: ${e.response!.statusCode}', e.response!.statusCode));
        }
      } else {
        log('Network error: ${e.message}');
        return Left(ServerFailure('Network error: ${e.message}', null));
      }
    } catch (e) {
      log('Unexpected error: $e');
      return Left(ServerFailure('Unexpected error: $e', null));
    }
  }

  @override
  Future<Either<Failure, String>> updateUser(String name, String phone) async {
    try {
      var res = await _dio.post(
        ApiConst.updateUser,
        data: {"newPhoneNumber": phone, "newUserName": name},
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (res.data['code'] == 200) {
        return Right(res.data['message']);
      } else {
        return Left(ServerFailure(
          'Error updating user',
          res.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(
        'Error updating user',
        null,
      ));
    }
  }
}
