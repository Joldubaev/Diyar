import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';

abstract class MenuRemoteDataSource {
  Future<Either<Failure, List<FoodModel>>> getProducts({String? foodName});
  Future<Either<Failure, List<FoodModel>>> getPopulartFoods();
  Future<Either<Failure, List<FoodModel>>> searchFoods({String? query});
  Future<Either<Failure, List<CategoryModel>>> getFoodsCategory();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;
  MenuRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, List<CategoryModel>>> getFoodsCategory() async {
    try {
      final res = await _dio.get(
        ApiConst.getCategories,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
      );

      if (res.statusCode == 200 && res.data != null) {
        final list = res.data as List;
        return Right(list.map((e) => CategoryModel.fromJson(e)).toList());
      }
      return const Left(Failure('Ошибка при получении категорий'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при получении категорий'));
    }
  }

  @override
  Future<Either<Failure, List<FoodModel>>> getProducts({String? foodName}) async {
    try {
      final res = await _dio.get(
        ApiConst.getAllFoodsByName,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
        queryParameters: {if (foodName != null) 'foodName': foodName},
      );

      if (res.statusCode == 200 && res.data != null) {
        final list = res.data as List;
        return Right(list.map((e) => FoodModel.fromJson(e)).toList());
      }
      return const Left(Failure('Ошибка при получении блюд'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при получении блюд'));
    }
  }

  @override
  Future<Either<Failure, List<FoodModel>>> searchFoods({String? query}) async {
    try {
      final res = await _dio.post(
        ApiConst.searchFoodsByName,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
        data: {
          if (query != null) 'foodName': query,
          'page': 1,
          'pageSize': 10,
        },
      );

      if (res.statusCode == 200 && res.data != null) {
        final list = res.data;
        return Right((list.first['foods'] as List).map((e) => FoodModel.fromJson(e)).toList());
      }
      return const Left(Failure('Ошибка при поиске блюд'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при поиске блюд'));
    }
  }

  @override
  Future<Either<Failure, List<FoodModel>>> getPopulartFoods() async {
    try {
      final res = await _dio.get(
        ApiConst.getPopularFoods,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
      );

      if (res.statusCode == 200 && res.data != null) {
        final list = res.data as List;
        return Right(list.map((e) => FoodModel.fromJson(e)).toList());
      }
      return const Left(Failure('Ошибка при получении популярных блюд'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при получении популярных блюд'));
    }
  }

  Failure _handleError(Object e, String fallbackMessage) {
    if (e is DioException) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : fallbackMessage;
      return Failure(msg!);
    }
    return Failure(fallbackMessage);
  }
}
