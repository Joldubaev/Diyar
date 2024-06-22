import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/core/error/exception.dart';
import 'package:diyar/features/curier/data/model/curier_model.dart';
import 'package:diyar/features/curier/data/model/get_user_moderl.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CurierDataSource {
  Future<List<CurierOrderModel>> getCurierOrders();
  Future<void> getFinishOrder(int orderId);
  Future<List<CurierOrderModel>> getCurierHistory();
  Future<GetUserModel> getUser();
}

class CurierDataSourceImpl extends CurierDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  CurierDataSourceImpl(this.dio, this.prefs);

  @override
  Future<GetUserModel> getUser() async {
    try {
      var res = await dio.post(ApiConst.getUser,
          data: {"email": prefs.getString(AppConst.email)},
          options: Options(
            headers:
                ApiConst.authMap(prefs.getString(AppConst.accessToken) ?? ''),
          ));
      if (res.statusCode == 200) {
        return GetUserModel.fromJson(res.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CurierOrderModel>> getCurierOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getCuriersAllOrder,
        options: Options(headers: ApiConst.authMap(token)),
      );
      if ([200, 201].contains(res.statusCode)) {
        return List<CurierOrderModel>.from(
          res.data['orders'].map((x) => CurierOrderModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting active orders');
      }
    } catch (e) {
      log(e.toString());
      throw Exception();
    }
  }

  @override
  Future<void> getFinishOrder(int orderId) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.post(
        ApiConst.getCuriersFinis,
        options: Options(
          headers: ApiConst.authMap(token),
        ),
        data: {'orderNumber': orderId},
      );
      if ([200, 201].contains(res.statusCode)) {
        return;
      } else {
        throw Exception('Error getting active orders');
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<CurierOrderModel>> getCurierHistory() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getCuriereOrderHistory,
        options: Options(
          headers: ApiConst.authMap(token),
        ),
      );
      if ([200, 201].contains(res.statusCode)) {
        return List<CurierOrderModel>.from(
          res.data['orders'].map((x) => CurierOrderModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting active orders');
      }
    } catch (e) {
      throw Exception();
    }
  }
}
