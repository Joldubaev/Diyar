import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'response_validator_mixin.dart';

/// Отдельный дата-сорс для операций оплаты заказов курьера.
abstract class CurierPaymentDataSource {
  /// PUT /courier/order/set-payment-status — отметить оплату заказа от лица курьера.
  Future<void> setOrderPaymentStatus({
    required int orderNumber,
    required String paymentStatus,
  });
}

@LazySingleton(as: CurierPaymentDataSource)
class CurierPaymentDataSourceImpl with ResponseValidatorMixin implements CurierPaymentDataSource {
  CurierPaymentDataSourceImpl(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

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

    validateResponse(res);
  }
}
