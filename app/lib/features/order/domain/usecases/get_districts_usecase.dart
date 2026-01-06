import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/order/domain/entities/district_entity.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:injectable/injectable.dart';

/// UseCase для получения списка районов
@injectable
class GetDistrictsUseCase {
  final OrderRepository _repository;

  GetDistrictsUseCase(this._repository);

  Future<Either<Failure, List<DistrictEntity>>> call({String? search}) {
    return _repository.getDistricts(search: search);
  }
}

