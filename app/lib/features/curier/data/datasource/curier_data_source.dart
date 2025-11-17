import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/curier/data/data.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CurierDataSource {
  Future<Either<Failure, List<CurierOrderModel>>> getCurierOrders();
  Future<Either<Failure, Unit>> getFinishOrder(int orderId);
  Future<Either<Failure, List<CurierOrderModel>>> getCurierHistory();
  Future<Either<Failure, GetUserModel>> getUser();
}

@LazySingleton(as: CurierDataSource)
class CurierDataSourceImpl extends CurierDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  CurierDataSourceImpl(this.dio, this.prefs);

  @override
  Future<Either<Failure, GetUserModel>> getUser() async {
    try {
      var res = await dio.post(ApiConst.getUser,
          data: {"phone": prefs.getString(AppConst.phone)},
          options: Options(
            headers: ApiConst.authMap(prefs.getString(AppConst.accessToken) ?? ''),
          ));
      if (res.data['code'] == 200) {
        return Right(GetUserModel.fromJson(res.data['message']));
      } else {
        return Left(ServerFailure('Ошибка получения данных пользователя', res.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure('Ошибка получения данных пользователя', null));
    }
  }

  @override
  Future<Either<Failure, List<CurierOrderModel>>> getCurierOrders() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getCuriersAllOrder,
        options: Options(headers: ApiConst.authMap(token)),
      );
      if ([200, 201].contains(res.data['code'])) {
        final orders = List<CurierOrderModel>.from(
          (res.data['message'] as List).map((x) => CurierOrderModel.fromJson(x)),
        );
        return Right(orders);
      } else {
        return Left(ServerFailure('Ошибка получения истории заказов курьера', res.statusCode));
      }
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure('Ошибка получения заказов курьера', null));
    }
  }

  @override
  Future<Either<Failure, Unit>> getFinishOrder(int orderId) async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getCuriersFinis,
        options: Options(
          headers: ApiConst.authMap(token),
        ),
        queryParameters: {'orderNumber': orderId},
      );
      if ([200, 201].contains(res.data['code'])) {
        return const Right(unit);
      } else {
        return Left(ServerFailure('Ошибка завершения заказа', res.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure('Ошибка завершения заказа', null));
    }
  }

  @override
  Future<Either<Failure, List<CurierOrderModel>>> getCurierHistory() async {
    try {
      var token = prefs.getString(AppConst.accessToken) ?? '';
      final res = await dio.get(
        ApiConst.getCuriereOrderHistory,
        options: Options(
          headers: ApiConst.authMap(token),
        ),
      );
      if ([200, 201].contains(res.data['code'])) {
        final orders = List<CurierOrderModel>.from(
          (res.data['message'] as List).map((x) => CurierOrderModel.fromJson(x)),
        );
        return Right(orders);
      } else {
        return Left(ServerFailure('Ошибка получения истории заказов курьера', res.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure('Ошибка получения истории заказов курьера', null));
    }
  }
}
