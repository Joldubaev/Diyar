import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/data/datasource/remote_datasource.dart';
import 'package:diyar/features/map/domain/domain.dart';
import 'package:fpdart/fpdart.dart' show Either;
import 'package:injectable/injectable.dart';

@LazySingleton(as: PriceRepository)
class PriceRepositoryImpl with RepositoryErrorHandler implements PriceRepository {
  final RemoteDataSource remoteDataSource;

  PriceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DeliveryPriceEntity>> getDistrictPrice({required String yandexId}) {
    return makeRequest(() async {
      final model = await remoteDataSource.getDistrictPrice(yandexId: yandexId);
      return model.toEntity();
    });
  }
}
