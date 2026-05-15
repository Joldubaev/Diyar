import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/active_order/data/data.dart';
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart';
import 'package:diyar/features/menu/data/models/food_model.dart';
import 'package:injectable/injectable.dart';

abstract class ActiveOrderRemoteDataSource {
  Future<List<OrderActiveItemModel>> getActiveOrders();
  Future<void> cancelOrder({required int orderNumber, required bool isPickup});
}

@LazySingleton(as: ActiveOrderRemoteDataSource)
class ActiveOrderRemoteDataSourceImpl implements ActiveOrderRemoteDataSource {
  static const _activePickupStatuses = {'Awaits', 'Processing', 'Cooked'};

  final Dio _dio;

  ActiveOrderRemoteDataSourceImpl(this._dio);

  /// Активные самовывозы: REST `get-all-actual-orders-by-user` их не отдаёт, только `pickup-orders/...`.
  Future<List<OrderActiveItemModel>> _fetchActivePickupOrders() async {
    try {
      final res = await _dio.get(
        ApiConst.getPickupHistoryOrders,
        queryParameters: {
          'pageNumber': 1,
          'pageSize': 50,
        },
      );
      final bodyCode = res.data['code'];
      final bodyOk = bodyCode == null || [200, 201].contains(bodyCode);
      if (![200, 201].contains(res.statusCode) || !bodyOk) return [];

      final message = res.data['message'];
      if (message is! Map) return [];

      final orders = message['orders'] as List<dynamic>? ?? [];
      final out = <OrderActiveItemModel>[];
      for (final raw in orders) {
        if (raw is! Map) continue;
        final u = UserPickupHistoryModel.fromJson(Map<String, dynamic>.from(raw));
        final m = _mapPickupHistoryToActiveItem(u);
        final s = m.status;
        if (s != null && _activePickupStatuses.contains(s)) {
          out.add(m);
        }
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  OrderActiveItemModel _mapPickupHistoryToActiveItem(UserPickupHistoryModel u) {
    return OrderActiveItemModel(
      id: u.id,
      userId: u.userId,
      userName: u.userName,
      userPhone: u.userPhone,
      orderNumber: u.orderNumber,
      dishesCount: u.dishesCount,
      foods: u.foods
          ?.map(
            (f) => FoodModel(
              name: f.name,
              price: f.price,
              quantity: f.quantity,
            ),
          )
          .toList(),
      address: null,
      comment: u.comment,
      paymentMethod: u.paymentMethod,
      price: u.price,
      timeRequest: u.timeRequest ?? u.prepareFor,
      status: u.status,
      paymentStatus: null,
      amountToReduce: u.amountToReduce?.round(),
      deliveryPrice: null,
    );
  }

  @override
  Future<List<OrderActiveItemModel>> getActiveOrders() async {
    try {
      final res = await _dio.get(ApiConst.getActualOrders);

      _validateResponse(res);

      final List list = res.data['message'] ?? [];
      final deliveryOrders = list
          .map((x) => OrderActiveItemModel.fromJson(Map<String, dynamic>.from(x as Map)))
          .toList();

      final pickupOrders = await _fetchActivePickupOrders();

      final seen = <int>{};
      final merged = <OrderActiveItemModel>[];
      for (final o in deliveryOrders) {
        final n = o.orderNumber;
        if (n != null) seen.add(n);
        merged.add(o);
      }
      for (final o in pickupOrders) {
        final n = o.orderNumber;
        if (n != null && seen.contains(n)) continue;
        if (n != null) seen.add(n);
        merged.add(o);
      }
      return merged;
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
      final path = isPickup ? ApiConst.cancelPickupOrder : ApiConst.cancelDeliveryOrder;

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
