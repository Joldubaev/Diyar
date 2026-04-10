import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/map/domain/entities/delivery_price_entity.dart';
import 'package:fpdart/fpdart.dart' show Either;

abstract class PriceRepository {
  Future<Either<Failure, DeliveryPriceEntity>> getDistrictPrice({required String yandexId});
}
