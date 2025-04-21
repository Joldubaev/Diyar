import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();
  Future<void> updateUser(String name, String phone);
  Future<void> deleteUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;
  final LocalStorage _prefs;

  UserRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<UserModel> getUser() async {
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
        return UserModel.fromJson(json);
      } else {
        throw ServerException('Error fetching user data', res.statusCode);
      }
    } catch (e) {
      log('[GET USER ERROR] $e');
      throw ServerException('Error fetching user data', null);
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final token = _prefs.getString(AppConst.accessToken);
      var res = await _dio.delete(
        ApiConst.deleteUser,
        options: Options(headers: ApiConst.authMap(token ?? '')),
      );

      if (res.statusCode != 200) {
        throw ServerException(
          'Error deleting user',
          res.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Check the status code and handle different scenarios
        if (e.response!.statusCode == 404) {
          log('Error: User not found (404). $e');
          throw Exception('User not found.');
        } else {
          log('Error: ${e.response!.statusCode} - ${e.response!.statusMessage}');
          throw Exception('Server error: ${e.response!.statusCode}');
        }
      } else {
        // If there's no response, it might be a network issue
        log('Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateUser(String name, String phone) async {
    try {
      var res = await _dio.post(
        ApiConst.updateUser,
        data: {"newPhoneNumber": phone, "newUserName": name},
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (res.statusCode != 200) {
        throw ServerException(
          'Error updating user',
          res.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(
        'Error updating user',
        null,
      );
    }
  }
}
