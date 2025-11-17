import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryReDatasource {
  Future<List<OrderActiveItemModel>> getHistoryOrders();
  Future<List<UserPickupHistoryModel>> getPickupHistory();
}

@LazySingleton(as: HistoryReDatasource)
class HistoryReDatasourceImpl implements HistoryReDatasource {
  SharedPreferences prefs;
  final Dio dio;
  HistoryReDatasourceImpl(this.dio, this.prefs);

  @override
  Future<List<OrderActiveItemModel>> getHistoryOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getOrderHistory,
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.data['code'])) {
        return List<OrderActiveItemModel>.from(
          res.data['message'].map((x) => OrderActiveItemModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting history orders');
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<UserPickupHistoryModel>> getPickupHistory() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getPickupHistoryOrders,
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.statusCode)) {
        final List<dynamic> orders = res.data['message'] as List<dynamic>;
        return List<UserPickupHistoryModel>.from(
          orders.map((x) => UserPickupHistoryModel.fromJson(x)),
        );
      } else {
        throw Exception('Error getting pickup history orders');
      }
    } catch (e) {
      debugPrint('Error in getPickupHistory: $e');
      throw Exception('Failed to get pickup history orders');
    }
  }
}
