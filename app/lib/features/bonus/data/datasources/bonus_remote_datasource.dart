import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/data/models/model.dart';
import 'package:injectable/injectable.dart';

abstract class BonusRemoteDataSource {
  Future<QrGenerateModel> generateQr();
}

@LazySingleton(as: BonusRemoteDataSource)
class BonusRemoteDataSourceImpl implements BonusRemoteDataSource {
  final Dio _dio;

  BonusRemoteDataSourceImpl(this._dio);

  @override
  Future<QrGenerateModel> generateQr() async {
    final response = await _dio.post(ApiConst.generateBonusQr);
    final data = response.data;
    if (data is! Map<String, dynamic> || !data.containsKey('message')) {
      throw const FormatException('Invalid response structure: missing "message" field');
    }
    final message = data['message'];
    if (message is! Map<String, dynamic>) {
      throw const FormatException('Field "message" must be a Map');
    }
    return QrGenerateModel.fromJson(message);
  }
}
