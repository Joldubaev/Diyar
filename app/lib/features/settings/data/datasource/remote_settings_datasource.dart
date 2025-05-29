import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import '../models/timer_model.dart';

abstract class RemoteSettingsDataSource {
 Future<Either<Failure, TimerModel>> getTimer();
}

class RemoteSettingsDataSourceImpl implements RemoteSettingsDataSource {
  final Dio _dio;

  RemoteSettingsDataSourceImpl(this._dio);

   @override
  Future<Either<Failure, TimerModel>> getTimer() async {
    try {
      final res = await _dio.get(ApiConst.getTimer);
      if (res.data['code'] == 200) {
        final data = res.data as Map<String, dynamic>;
        final timerModel = TimerModel.fromJson(data['message']);
        return Right(timerModel);
      } else {
        return Left(ServerFailure(res.data['message'], null));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}