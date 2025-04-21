import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:diyar/features/menu/menu.dart';


class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;

  MenuRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<FoodEntity>>> getProducts({String? foodName}) async {
    final result = await _remoteDataSource.getProducts(foodName: foodName);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> searchFoods({String? query}) async {
    final result = await _remoteDataSource.searchFoods(query: query);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getPopularFoods() async {
    final result = await _remoteDataSource.getPopulartFoods();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getFoodsByCategory() async {
    final result = await _remoteDataSource.getFoodsCategory();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((e) => e.toEntity()).toList()),
    );
  }
}
