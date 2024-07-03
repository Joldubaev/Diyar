import 'package:dio/dio.dart';
import 'package:diyar/shared/constants/api_const/api_const.dart';
import 'package:diyar/shared/constants/app_const/app_const.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();
  Future<void> updateEmail();
  Future<void> updatePhone();
  Future<void> updateUser(String name, String phone);
  Future<void> deleteUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  UserRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<UserModel> getUser() async {
    try {
      var res = await _dio.post(ApiConst.getUser,
          data: {"phone": _prefs.getString(AppConst.phone)},
          options: Options(
            headers:
                ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
          ));
      if (res.statusCode == 200) {
        return UserModel.fromJson(res.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateEmail() {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhone() {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(String name, String phone) async {
    try {
      var res = await _dio.post(
        ApiConst.updateUser,
        data: {"newPhoneNumber": phone, "newUserName": name},
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
