import 'package:dartz/dartz.dart';
import 'package:diyar/core/mixins/repository_error_handler.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CurierRepository)
class CurierRepositoryImpl with RepositoryErrorHandler implements CurierRepository {
  final CurierDataSource dataSource;

  CurierRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<CurierEntity>>> getCurierOrders() {
    return makeRequest(() async {
      final models = await dataSource.getCurierOrders();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> getFinishOrder(int orderId) {
    return makeRequest(() async {
      await dataSource.getFinishOrder(orderId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, List<CurierEntity>>> getCurierHistory({
    String? startDate,
    String? endDate,
    int page = 1,
    int pageSize = 10,
  }) {
    return makeRequest(() async {
      final models = await dataSource.getCurierHistory(
        startDate: startDate,
        endDate: endDate,
        page: page,
        pageSize: pageSize,
      );
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, GetUserEntity>> getUser() {
    return makeRequest(() async {
      final model = await dataSource.getUser();
      return model.toEntity();
    });
  }
}
