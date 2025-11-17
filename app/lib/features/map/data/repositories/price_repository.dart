import 'package:diyar/features/map/data/datasource/remote_datasource.dart';
import 'package:diyar/features/map/data/models/price_model.dart';
import 'package:injectable/injectable.dart';

abstract class PriceRepository {
  Future<PriceModel> getDistrictPrice({required String yandexId});
}

@LazySingleton(as: PriceRepository)
class PriceRepositoryImpl implements PriceRepository {
  final RemoteDataSource remoteDataSource;

  PriceRepositoryImpl(this.remoteDataSource);

  @override
  Future<PriceModel> getDistrictPrice({required String yandexId}) async {
    return await remoteDataSource.getDistrictPrice(yandexId: yandexId);
  }
}
