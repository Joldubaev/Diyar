import 'package:dartz/dartz.dart';
import 'package:diyar/core/mixins/repository_error_handler.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/order_detail/data/datasource/order_detail_remote_data_source.dart';
import 'package:diyar/features/order_detail/data/models/order_detail_model.dart';
import 'package:diyar/features/order_detail/domain/domain.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderDetailRepository)
class OrderDetailRepositoryImpl with RepositoryErrorHandler implements OrderDetailRepository {
  final OrderDetailRemoteDataSource _dataSource;

  OrderDetailRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, OrderDetailEntity>> getOrderDetail({required int orderNumber}) {
    return makeRequest(() async {
      final model = await _dataSource.getOrderDetail(orderNumber: orderNumber);
      return model.toEntity();
    });
  }
}
