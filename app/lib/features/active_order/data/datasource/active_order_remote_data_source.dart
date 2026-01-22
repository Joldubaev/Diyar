import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/data/data.dart';
import 'package:injectable/injectable.dart';

abstract class ActiveOrderRemoteDataSource {
  Future<List<OrderActiveItemModel>> getActiveOrders();
  Future<void> cancelOrder({required int orderNumber, required bool isPickup});
}

@LazySingleton(as: ActiveOrderRemoteDataSource)
class ActiveOrderRemoteDataSourceImpl implements ActiveOrderRemoteDataSource {
  final Dio _dio;

  ActiveOrderRemoteDataSourceImpl(this._dio);

  @override
  Future<List<OrderActiveItemModel>> getActiveOrders() async {
    try {
      final res = await _dio.get(ApiConst.getActualOrders);

      _validateResponse(res);

      final List list = res.data['message'] ?? [];
      return list.map((x) => OrderActiveItemModel.fromJson(x)).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message']?.toString() ?? 'Network error',
        e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Parsing error: $e', null);
    }
  }

  @override
  Future<void> cancelOrder({required int orderNumber, required bool isPickup}) async {
    try {
      // Выбираем эндпоинт в зависимости от типа заказа
      final path = isPickup
          ? '${ApiConst.baseUrl}/pickup-orders/cancel-order-by-user'
          : '${ApiConst.baseUrl}/orders/cancel-order-by-user';

      final res = await _dio.post(
        path,
        data: {"orderNumber": orderNumber},
      );

      _validateResponse(res);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message']?.toString() ?? 'Не удалось отменить заказ',
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
