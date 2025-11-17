import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:injectable/injectable.dart';

abstract class AboutUsRemoteDataSource {
  Future<AboutUsModel> getAboutUs({required String type});
}

@LazySingleton(as: AboutUsRemoteDataSource)
class AboutUsRemoteDataSourceImpl implements AboutUsRemoteDataSource {
  final Dio _dio;
  final LocalStorage _localStorage;

  AboutUsRemoteDataSourceImpl(this._dio, this._localStorage);
  String get token => _localStorage.getString(AppConst.accessToken) ?? "";

  @override
  Future<AboutUsModel> getAboutUs({required String type}) async {
    try {
      var res = await _dio.get(
        ApiConst.getAboutUs,
        queryParameters: {
          "about": type,
        },
        options: Options(headers: BaseHelper.authToken(token)),
      );

      if (res.data['code'] == 200) {
        if (res.data['code'] != null) {
          log("About Us Response: ${res.data['message']}");
          return AboutUsModel.fromJson(res.data['message']);
        } else {
          throw ServerException(
            "No data found",
            res.statusCode,
          );
        }
      } else {
        throw ServerException(
          "Error: ${res.statusCode}",
          res.statusCode,
        );
      }
    } catch (e) {
      log("Error: $e");
      throw ServerException(
        "Failed to fetch data",
        (e is DioException) ? e.response?.statusCode : null,
      );
    }
  }
}
