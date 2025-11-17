import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:diyar/features/order/data/datasources/order_remote_datasource.dart';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:diyar/features/map/map.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _orderDataSource;

  OrderRepositoryImpl(this._orderDataSource);

  @override
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query}) async {
    return _orderDataSource.getGeoSuggestions(query: query);
  }

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderEntity orderEntity) async {
    try {
      final orderModel = CreateOrderModel.fromEntity(orderEntity);
      final result = await _orderDataSource.createOrder(orderModel);
      return  result.fold(
        (failure) => Left(failure),
        (response) => Right(response),
      );

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
}
