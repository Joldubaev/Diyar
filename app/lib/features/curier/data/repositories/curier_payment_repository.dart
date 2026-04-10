import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/core/mixins/repository_error_handler.dart';
import 'package:diyar/features/curier/data/datasource/curier_payment_data_source.dart';
import 'package:diyar/features/curier/domain/repository/curier_payment_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CurierPaymentRepository)
class CurierPaymentRepositoryImpl with RepositoryErrorHandler implements CurierPaymentRepository {
  CurierPaymentRepositoryImpl(this._dataSource);

  final CurierPaymentDataSource _dataSource;

  @override
  Future<Either<Failure, Unit>> setOrderPaymentStatus({
    required int orderNumber,
    required String paymentStatus,
  }) {
    return makeRequest(() async {
      await _dataSource.setOrderPaymentStatus(
        orderNumber: orderNumber,
        paymentStatus: paymentStatus,
      );
      return unit;
    });
  }
}

