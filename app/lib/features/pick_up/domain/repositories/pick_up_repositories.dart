import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/pick_up/domain/entities/pickup_order_entity.dart';

/// Базовый контракт репозитория самовывоза.
abstract class PickUpRepositories {
  Future<Either<Failure, String>> getPickupOrder(PickupOrderEntity order);
}

/// Алиас с корректным именем для использования в слоях presentation/domain.
typedef PickUpRepository = PickUpRepositories;
