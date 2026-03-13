import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Отдельный дата-сорс для операций оплаты заказов курьера.
abstract class CurierPaymentDataSource {
  /// PUT /courier/order/set-payment-status — отметить оплату заказа от лица курьера.
  Future<void> setOrderPaymentStatus({
    required int orderNumber,
    required String paymentStatus,
  });
}

@LazySingleton(as: CurierPaymentDataSource)
class CurierPaymentDataSourceImpl implements CurierPaymentDataSource {
  CurierPaymentDataSourceImpl(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

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
  Future<void> setOrderPaymentStatus({
    required int orderNumber,
    required String paymentStatus,
  }) async {
    final token = _prefs.getString(AppConst.accessToken) ?? '';
    final res = await _dio.put(
      ApiConst.setOrderPaymentStatusCourier,
      data: {
        'orderNumber': orderNumber,
        'paymentStatus': paymentStatus,
      },
      options: Options(
        headers: ApiConst.authMap(token),
      ),
    );

    _validateResponse(res);
  }
}

