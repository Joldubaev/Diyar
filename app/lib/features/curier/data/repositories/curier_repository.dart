import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CurierRepository)
class CurierRepositoryImpl extends CurierRepository {
  final CurierDataSource dataSource;

  CurierRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<CurierEntity>>> getCurierOrders() async {
    final result = await dataSource.getCurierOrders();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> getFinishOrder(int orderId) async {
    return await dataSource.getFinishOrder(orderId);
  }

  @override
  Future<Either<Failure, List<CurierEntity>>> getCurierHistory() async {
    final result = await dataSource.getCurierHistory();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, GetUserEntity>> getUser() async {
    final result = await dataSource.getUser();
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }
}
