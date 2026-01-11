import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/data/models/model.dart';
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
        return Right(response.data['message']?.toString() ?? 'Success');
      }
      return Left(ServerFailure('Order creation failed', response.statusCode));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDio(e));
    } catch (e) {
      return Left(ServerFailure(e.toString(), null));
    }
  }
}
