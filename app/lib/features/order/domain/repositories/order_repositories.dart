import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/order/domain/entities/entities.dart';

abstract class OrderRepository {
  Future<Either<Failure, Unit>> createOrder(CreateOrderEntity order);
  Future<Either<Failure, List<DistrictEntity>>> getDistricts({String? search});
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query});
}
