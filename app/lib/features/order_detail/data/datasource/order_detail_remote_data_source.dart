import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order_detail/data/data.dart';
import 'package:injectable/injectable.dart';

abstract class OrderDetailRemoteDataSource {
  Future<OrderDetailModel> getOrderDetail({required int orderNumber});
}

@LazySingleton(as: OrderDetailRemoteDataSource)
class OrderDetailRemoteDataSourceImpl implements OrderDetailRemoteDataSource {
  final Dio _dio;

  OrderDetailRemoteDataSourceImpl(this._dio);

  @override
  Future<OrderDetailModel> getOrderDetail({required int orderNumber}) async {
    try {
      final res = await _dio.post(
        ApiConst.getOrderItem,
        data: {"orderNumber": orderNumber},
      );

      // Проверяем внутренний код API
      _validateResponse(res);

      return OrderDetailModel.fromJson(res.data['message']);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message']?.toString() ?? 'Network error',
        e.response?.statusCode,
      );
    }
  }

  // Приватный хелпер для валидации ответа
  void _validateResponse(Response res) {
    final code = res.data['code'];
    if (![200, 201].contains(code)) {
      throw ServerException(
        res.data['message']?.toString() ?? 'Error from server',
        code is int ? code : null,
      );
    }
  }
}
