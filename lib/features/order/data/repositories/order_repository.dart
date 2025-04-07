import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/map/data/models/location_model.dart';
import 'package:diyar/features/order/data/models/create_payment_model.dart';
import 'package:diyar/features/order/data/models/distric_model.dart';
import 'package:diyar/features/order/order.dart';

abstract class OrderRepository {
  Future<Either<Failure, String>> createOrder(CreateOrderModel order);
  Future<Either<Failure, String>> getPaymnent(PaymentModel order); // 🔥 Вернули String (а не void)
  Future<Either<Failure, void>> getPickupOrder(PickupOrderModel order);
  Future<Either<Failure, List<DistricModel>>> getDistricts({String? search});
  Future<LocationModel> getGeoSuggestions({required String query});
}



class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  @override
  Future<LocationModel> getGeoSuggestions({required String query}) async {
    return _orderDataSource.getGeoSuggestions(query: query);
  }

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderModel order) async {
    return _orderDataSource.createOrder(order);
  }

 @override
Future<Either<Failure, String>> getPaymnent(PaymentModel order) async {
  return _orderDataSource.getPaymnent(order); // ✅ Должен возвращать Either<Failure, String>
}



  @override
  Future<Either<Failure, List<DistricModel>>> getDistricts({String? search}) async {
    return _orderDataSource.getDistricts(search: search);
  }

  @override
  Future<Either<Failure, void>> getPickupOrder(PickupOrderModel order) async {
    try {
      await _orderDataSource.getPickupOrder(order);
      return const Right(unit); // ✅ Используем unit вместо null
    } catch (e) {
      return Left(ServerFailure("❌ Ошибка при самовывозе: $e"));
    }
  }
}
