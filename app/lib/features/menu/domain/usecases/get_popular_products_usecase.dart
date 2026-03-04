import 'package:dartz/dartz.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPopularProductsUseCase {
  final MenuRepository _repository;

  GetPopularProductsUseCase(this._repository);

  Future<Either<Failure, List<FoodEntity>>> call() {
    return _repository.getPopularFoods();
  }
}
