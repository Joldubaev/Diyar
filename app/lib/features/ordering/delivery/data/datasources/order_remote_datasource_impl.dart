import 'dart:developer' as dev;

import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/ordering/delivery/data/models/model.dart';
import 'package:injectable/injectable.dart';
import 'order_remote_datasource.dart';

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final Dio _dio;

  OrderRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderModel order) async {
    try {
      final response = await _dio.post(
        ApiConst.createOrder,
        data: order.toApiJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msgField = response.data is Map ? response.data['message'] : null;
        // Server may return 200 with an error object in the message field
        if (msgField is Map) {
          final errorMsg = msgField['message']?.toString() ??
              msgField['developerMessage']?.toString() ??
              'Ошибка создания заказа';
          return Left(ServerFailure(errorMsg, response.statusCode));
        }
        return Right(msgField?.toString() ?? 'Success');
      }
      final msg = response.data is Map
          ? (response.data['message'] ?? response.data['error'])?.toString() ?? 'Order creation failed'
          : 'Order creation failed';
      return Left(ServerFailure(msg, response.statusCode));
    } on DioException catch (e) {
      if (e.response != null) {
        dev.log('createOrder DioException: status=${e.response?.statusCode} data=${e.response?.data}');
      }
      return Left(ServerFailure.fromDio(e));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
