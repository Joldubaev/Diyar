import 'package:dartz/dartz.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/order/domain/repositories/order_repositories.dart';
import 'package:injectable/injectable.dart';

/// UseCase для получения геоподсказок
@injectable
class GetGeoSuggestionsUseCase {
  final OrderRepository _repository;

  GetGeoSuggestionsUseCase(this._repository);

  Future<Either<Failure, LocationModel>> call({required String query}) {
    return _repository.getGeoSuggestions(query: query);
  }
}

