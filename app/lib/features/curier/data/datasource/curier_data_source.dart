import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/curier/data/data.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CurierDataSource {
  Future<List<CurierOrderModel>> getCurierOrders();
  Future<void> getFinishOrder(int orderId);
  Future<void> setShift(bool onShift);

  /// GET /courier/shift — текущий статус смены. Ответ: { "onShift": true } или { "onShift": false }.
  Future<bool> getShiftStatus();
  Future<List<CurierOrderModel>> getCurierHistory({
    String? startDate,
    String? endDate,
    int page = 1,
    int pageSize = 10,
  });
  Future<GetUserModel> getUser();
}

@LazySingleton(as: CurierDataSource)
class CurierDataSourceImpl implements CurierDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  CurierDataSourceImpl(this.dio, this.prefs);

  void _validateResponse(Response res) {
    final code = res.data['code'];
    if (![200, 201].contains(code)) {
      throw ServerException(
        res.data['message']?.toString() ?? 'Error from server',
        code is int ? code : null,
      );
    }
  }

  @override
  Future<GetUserModel> getUser() async {
    final res = await dio.post(
      ApiConst.getUser,
      data: {"phone": prefs.getString(AppConst.phone)},
      options: Options(
        headers: ApiConst.authMap(prefs.getString(AppConst.accessToken) ?? ''),
      ),
    );

    _validateResponse(res);

    return GetUserModel.fromJson(res.data['message']);
  }

  @override
  Future<List<CurierOrderModel>> getCurierOrders() async {
    final token = prefs.getString(AppConst.accessToken) ?? '';
    final res = await dio.get(
      ApiConst.getCuriersAllOrder,
      options: Options(headers: ApiConst.authMap(token)),
    );

    _validateResponse(res);

    final List list = res.data['message'] ?? [];
    return list.map((x) => CurierOrderModel.fromJson(x as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> getFinishOrder(int orderId) async {
    final token = prefs.getString(AppConst.accessToken) ?? '';
    final res = await dio.get(
      ApiConst.getCuriersFinis,
      options: Options(
        headers: ApiConst.authMap(token),
      ),
      queryParameters: {'orderNumber': orderId},
    );

    _validateResponse(res);
  }

  @override
  Future<void> setShift(bool onShift) async {
    final token = prefs.getString(AppConst.accessToken) ?? '';
    final res = await dio.post(
      ApiConst.courierShift,
      data: {'onShift': onShift},
      options: Options(headers: ApiConst.authMap(token)),
    );
    _validateResponse(res);
  }

  @override
  Future<bool> getShiftStatus() async {
    final token = prefs.getString(AppConst.accessToken) ?? '';
    final res = await dio.get(
      ApiConst.courierShift,
      options: Options(headers: ApiConst.authMap(token)),
    );
    if (res.data is Map && (res.data as Map).containsKey('code')) {
      _validateResponse(res);
    }
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final onShift = data['onShift'];
      if (onShift is bool) return onShift;
      final message = data['message'];
      if (message is Map && message['onShift'] is bool) {
        return message['onShift'] as bool;
      }
    }
    return true;
  }

  @override
  Future<List<CurierOrderModel>> getCurierHistory({
    String? startDate,
    String? endDate,
    int page = 1,
    int pageSize = 10,
  }) async {
    final token = prefs.getString(AppConst.accessToken) ?? '';

    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['startDate'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['endDate'] = endDate;
    }

    final res = await dio.get(
      ApiConst.getCuriereOrderHistory,
      options: Options(
        headers: ApiConst.authMap(token),
      ),
      queryParameters: queryParams,
    );

    _validateResponse(res);

    final message = res.data['message'];
    List<dynamic> ordersList = [];

    if (message is Map<String, dynamic>) {
      if (message['orders'] != null && message['orders'] is List) {
        ordersList = message['orders'] as List;
      }
    } else if (message is List) {
      ordersList = message;
    }

    return ordersList.map((x) => CurierOrderModel.fromJson(x as Map<String, dynamic>)).toList();
  }
}
