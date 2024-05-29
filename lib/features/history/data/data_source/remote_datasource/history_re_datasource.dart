import 'package:dio/dio.dart';
import 'package:diyar/features/history/history.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryReDatasource {
  Future<OrderActiveItemModel> getOrderItem({required int num});
  Future<List<ActiveOrderModel>> getActiveOrders();
  Future<List<OrderActiveItemModel>> getHistoryOrders();
}

class HistoryReDatasourceImpl implements HistoryReDatasource {
  SharedPreferences prefs;
  final Dio dio;
  HistoryReDatasourceImpl(this.dio, this.prefs);

  @override
  Future<OrderActiveItemModel> getOrderItem({required int num}) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.post(
        ApiConst.getOrderItem,
        data: {"orderNumber": num},
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.statusCode)) {
        return OrderActiveItemModel.fromJson(res.data['order']);
      } else {
        throw Exception('Error getting order item');
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<ActiveOrderModel>> getActiveOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getActualOrders,
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.statusCode)) {
        return List<ActiveOrderModel>.from(res.data['orders'].map((x) => ActiveOrderModel.fromJson(x)));
      } else {
        throw Exception('Error getting active orders');
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<OrderActiveItemModel>> getHistoryOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getOrderHistory,
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.statusCode)) {
        return List<OrderActiveItemModel>.from(
          res.data['orders'].map((x) => OrderActiveItemModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting history orders');
      }
    } catch (e) {
      throw Exception();
    }
  }
}
