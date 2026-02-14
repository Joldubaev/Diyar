import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PickUpRepositories)
class PickUpRepository extends PickUpRepositories {
  final RemotePickUpDataSource remoteDataSource;

  PickUpRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> getPickupOrder(PickupOrderEntity orderEntity) async {
    try {
      final model = PickupOrderModel.fromEntity(orderEntity);
      final result = await remoteDataSource.getPickupOrder(model);
      return result;
    } catch (e) {
      return Left(ServerFailure('Error fetching pickup order: $e', null));
    }
  }
}
