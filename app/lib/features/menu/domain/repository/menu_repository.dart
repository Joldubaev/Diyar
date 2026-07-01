import 'package:fpdart/fpdart.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/menu/domain/domain.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<CategoryFoodEntity>>> getProducts({String? foodName});
  Future<Either<Failure, List<FoodEntity>>> searchFoods({String? query});
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods();

  /// Блок «Так же заказывают». Пустой список = блок скрыть (в т.ч. при 404).
  Future<Either<Failure, List<FoodEntity>>> getFrequentlyOrderedFoods();
  Future<Either<Failure, List<CategoryEntity>>> getFoodsCategory();
}
