import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/data/models/restaurant_model.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AboutUsRemoteDataSource {
  Future<AboutUsModel> getAboutUs({required String type});
}

class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  SharedPreferences prefs;
  final Dio _dio;

  AboutUsRemoteDataSourceImpl(this.prefs, this._dio);

  @override
  Future<AboutUsModel> getAboutUs({required String type}) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';

      var res = await _dio.get(
        ApiConst.getAboutUs(type: type),
        options: Options(
          headers: ApiConst.authMap(token),
        ),
      );

      if (res.statusCode == 200) {
        if (res.data != null) {
          log("About Us Response: ${res.data}");
          return AboutUsModel.fromJson(res.data);
        } else {
          throw ServerException();
        }
      } else {
        throw ServerException();
      }
    } catch (e) {
      log("Error: $e");
      throw ServerException();
    }
  }
}
