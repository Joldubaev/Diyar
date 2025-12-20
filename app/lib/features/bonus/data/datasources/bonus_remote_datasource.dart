import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/bonus/data/models/model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BonusRemoteDataSource {
  /// Генерирует QR код для бонусной системы
  Future<Either<Failure, QrGenerateModel>> generateQr();
}

@LazySingleton(as: BonusRemoteDataSource)
class BonusRemoteDataSourceImpl implements BonusRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  BonusRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<Either<Failure, QrGenerateModel>> generateQr() async {
    try {
      final response = await _dio.post(
        ApiConst.generateBonusQr,
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      if (response.statusCode == 200) {
        final message = response.data['message'] as Map<String, dynamic>?;
        if (message == null) {
          return Left(ServerFailure('Некорректный ответ от сервера: отсутствует поле message', 200));
        }

        try {
          final model = QrGenerateModel.fromJson(message);
          return Right(model);
        } catch (e) {
          return Left(ServerFailure(
            'Ошибка парсинга данных: ${e.toString()}',
            200,
          ));
        }
      } else {
        return Left(ServerFailure(
          response.data?['message']?.toString() ?? 'Failed to generate QR',
          response.statusCode,
        ));
      }
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(
          e.message ?? 'Network error during QR generation',
          e.response?.statusCode,
        ));
      }
      return Left(ServerFailure('Exception during QR generation: ${e.toString()}', null));
    }
  }
}
