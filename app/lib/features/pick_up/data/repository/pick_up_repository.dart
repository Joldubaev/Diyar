import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/pick_up/pick_up.dart';

class PickUpRepository extends PickUpRepositories {
  final RemotePickUpDataSource remoteDataSource;

  PickUpRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Unit>> getPickupOrder(PickupOrderEntity orderEntity) async {
    try {
      final orderModel = PickupOrderModel.fromEntity(orderEntity);
      return await remoteDataSource.getPickupOrder(orderModel);
    } catch (e) {
      return Left(ServerFailure(
          'Repository Error: Failed to map PickupOrderEntity or during datasource call: ${e.toString()}', null));
    }
  }
}
