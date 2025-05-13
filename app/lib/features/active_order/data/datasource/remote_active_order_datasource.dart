import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ActiveOrderRemoteDataSource {
  Future<OrderActiveItemModel> getOrderItem({required int num});
  Future<List<OrderActiveItemModel>> getActiveOrders();
}

class ActiveOrderRemoteDataSourceImpl implements ActiveOrderRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  ActiveOrderRemoteDataSourceImpl(this.dio, this.prefs);

  @override
  Future<OrderActiveItemModel> getOrderItem({required int num}) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.post(
        ApiConst.getOrderItem,
        data: {"orderNumber": num},
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.data['code'])) {
        return OrderActiveItemModel.fromJson(res.data['message']);
      } else {
        throw Exception('Error getting order item');
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<OrderActiveItemModel>> getActiveOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getActualOrders,
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.data['code'])) {
        return List<OrderActiveItemModel>.from(
          res.data['message'].map((x) => OrderActiveItemModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting active orders');
      }
    } catch (e, s) {
      // Логируем ошибку для отладки
      log('Ошибка получения активных заказов: $e\n$s');
      throw Exception();
    }
  }
}
