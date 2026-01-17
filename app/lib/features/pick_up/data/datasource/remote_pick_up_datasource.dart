import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/pick_up/pick_up.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RemotePickUpDataSource {
  Future<Either<Failure, String>> getPickupOrder(PickupOrderModel order);
}

@LazySingleton(as: RemotePickUpDataSource)
class RemotePickUpDataSourceImpl implements RemotePickUpDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;
  RemotePickUpDataSourceImpl(this._dio, this._prefs);

  @override
  Future<Either<Failure, String>> getPickupOrder(PickupOrderModel order) async {
    try {
      final requestData = order.toApiJson();
      log('Pickup order request data: $requestData');
      var res = await _dio.post(
        ApiConst.getPickupOrder,
        data: requestData,
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if ([200, 201].contains(res.statusCode)) {
        return Right(res.data['message']);
      } else {
        log('Failed to pickup order: ${res.statusCode} ${res.data}');
        return Left(ServerFailure(res.data?['message']?.toString() ?? 'Failed to pickup order', res.statusCode));
      }
    } catch (e, stacktrace) {
      log('Error in getPickupOrder: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        // Логируем ответ сервера для отладки
        if (e.response != null) {
          log('Response data: ${e.response?.data}');
          log('Response status: ${e.response?.statusCode}');
        }
        // Используем fromDio для лучшей обработки ошибок
        return Left(ServerFailure.fromDio(e));
      }
      return Left(ServerFailure('Exception during pickup order: ${e.toString()}', null));
    }
  }
}
