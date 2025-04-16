import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../map/data/models/location_model.dart';
import '../models/distric_model.dart';
import '../../order.dart';

abstract class OrderRepository {
  // Future<List<String>> getOrderHistory();
  Future<void> createOrder(CreateOrderModel order);
  Future<void> getPickupOrder(PickupOrderModel order);
  Future<Either<Failure, List<DistricModel>>> getDistricts( {String? search});
  Future<LocationModel> getGeoSuggestions({required String query});
}

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  // @override
  // Future<List<String>> getOrderHistory() async {
  //   return _orderDataSource.getOrderHistory();
  // }

  @override
  Future<LocationModel> getGeoSuggestions({required String query}) async {
    return _orderDataSource.getGeoSuggestions(query: query);
  }

  @override
  Future<void> createOrder(CreateOrderModel order) async {
    return _orderDataSource.createOrder(order);
  }

  @override
  Future<Either<Failure, List<DistricModel>>> getDistricts(
      {String? search}
  ) async {
    return _orderDataSource.getDistricts( search: search);
  }

  @override
  Future<void> getPickupOrder(PickupOrderModel order) async {
    return _orderDataSource.getPickupOrder(order);
  }
}
