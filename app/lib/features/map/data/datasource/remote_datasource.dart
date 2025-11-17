import 'package:dio/dio.dart';
import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/features/map/data/models/price_model.dart';
import 'package:injectable/injectable.dart';

abstract class RemoteDataSource {
  Future<PriceModel> getDistrictPrice({
    required String yandexId,
  });
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;

  RemoteDataSourceImpl(this._dio);

  @override
  Future<PriceModel> getDistrictPrice({
    required String yandexId,
  }) async {
    final response = await _dio.get(
      ApiConst.getPrice(id: yandexId),
    );

    if (response.statusCode == 200) {
      // Извлекаем данные из поля message
      final data = response.data['message'] ?? response.data;
      return PriceModel.fromJson(data);
    } else {
      throw Exception('Failed to load district price');
    }
  }
}
