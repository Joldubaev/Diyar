import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/menu/domain/domain.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<FoodEntity>>> getProducts({String? foodName});
  Future<Either<Failure, List<FoodEntity>>> searchFoods({String? query});
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods();
  Future<Either<Failure, List<CategoryEntity>>> getFoodsByCategory();
}
