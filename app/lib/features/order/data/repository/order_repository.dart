import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:diyar/features/order/data/datasources/order_remote_datasource.dart';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:diyar/features/map/map.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  // @override
  // Future<List<String>> getOrderHistory() async {
  //   return _orderDataSource.getOrderHistory();
  // }

  @override
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query}) async {
    return _orderDataSource.getGeoSuggestions(query: query);
  }

  @override
  Future<Either<Failure, Unit>> createOrder(CreateOrderEntity orderEntity) async {
    try {
      final orderModel = CreateOrderModel.fromEntity(orderEntity);
      return await _orderDataSource.createOrder(orderModel);
    } catch (e) {
      return Left(ServerFailure(
          'Repository Error: Failed to map CreateOrderEntity or during datasource call: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, List<DistrictEntity>>> getDistricts({String? search}) async {
    try {
      final result = await _orderDataSource.getDistricts(search: search);
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(ServerFailure('Repository Error: Failed to get districts or map them: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, Unit>> getPickupOrder(PickupOrderEntity orderEntity) async {
    try {
      final orderModel = PickupOrderModel.fromEntity(orderEntity);
      return await _orderDataSource.getPickupOrder(orderModel);
    } catch (e) {
      return Left(ServerFailure(
          'Repository Error: Failed to map PickupOrderEntity or during datasource call: ${e.toString()}', null));
    }
  }
}
