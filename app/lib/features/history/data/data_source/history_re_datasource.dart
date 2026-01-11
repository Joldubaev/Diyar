import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/features/history/data/model/pickup_history_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HistoryReDatasource {
  Future<List<OrderActiveItemModel>> getHistoryOrders();
  Future<PickupHistoryResponseModel> getPickupHistory({int pageNumber = 1, int pageSize = 10});
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
  Future<PickupHistoryResponseModel> getPickupHistory({int pageNumber = 1, int pageSize = 10}) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getPickupHistoryOrders,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        options: Options(headers: ApiConst.authMap(token)),
      );

      if ([200, 201].contains(res.statusCode)) {
        final List<dynamic> orders = res.data['message']['orders'] as List<dynamic>;
        final totalCount = res.data['message']['totalCount'] as int? ?? orders.length;
        final currentPage = res.data['message']['currentPage'] as int? ?? pageNumber;
        final returnedPageSize = res.data['message']['pageSize'] as int? ?? pageSize;
        final totalPages = res.data['message']['totalPages'] as int? ?? ((totalCount + returnedPageSize - 1) ~/ returnedPageSize);
        
        return PickupHistoryResponseModel(
          orders: List<UserPickupHistoryModel>.from(
            orders.map((x) => UserPickupHistoryModel.fromJson(x)),
          ),
          totalCount: totalCount,
          currentPage: currentPage,
          pageSize: returnedPageSize,
          totalPages: totalPages,
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
