import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order_detail/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrderDetailUseCase {
  final OrderDetailRepository _repository;

  GetOrderDetailUseCase(this._repository);

  Future<Either<Failure, OrderDetailEntity>> call({required int orderNumber}) {
    return _repository.getOrderDetail(orderNumber: orderNumber);
  }
}
