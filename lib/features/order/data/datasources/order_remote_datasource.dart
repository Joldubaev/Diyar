import 'package:dio/dio.dart';
import 'package:diyar/features/order/data/data.dart';
import 'package:diyar/features/order/data/models/pickup_order_model.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderRemoteDataSource {
  Future<List<String>> getOrderHistory();
  Future<void> createOrder(CreateOrderModel order);
  Future<void> getPickupOrder(PickupOrderModel order);
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  OrderRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<void> getPickupOrder(PickupOrderModel order) async {
    try {
      var res = await _dio.post(
        ApiConst.getPickupOrder,
        data: order.toJson(),
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (![200, 201].contains(res.statusCode)) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> createOrder(CreateOrderModel order) async {
    try {
      var res = await _dio.post(
        ApiConst.createOrder,
        data: order.toJson(),
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (![200, 201].contains(res.statusCode)) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> getOrderHistory() async {
    try {
      var res = await _dio.get(
        ApiConst.getOrderHistory,
        options: Options(
          headers: ApiConst.authMap(
            _prefs.getString(AppConst.accessToken) ?? '',
          ),
        ),
      );
      if (res.statusCode == 200) {
        return List<String>.from(res.data['data']);
      } else {
        throw Exception('Failed to get order history');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
