import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/curier/domain/domain.dart';

abstract class CurierRepository {
  Future<Either<Failure, List<CurierEntity>>> getCurierOrders();
  Future<Either<Failure, Unit>> getFinishOrder(int orderId);
  Future<Either<Failure, List<CurierEntity>>> getCurierHistory();
  Future<Either<Failure, GetUserEntity>> getUser();
}