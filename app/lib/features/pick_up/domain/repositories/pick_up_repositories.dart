import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/pick_up/domain/entities/pickup_order_entity.dart';

abstract class PickUpRepositories {
  Future<Either<Failure, String>> getPickupOrder(PickupOrderEntity order);
}
