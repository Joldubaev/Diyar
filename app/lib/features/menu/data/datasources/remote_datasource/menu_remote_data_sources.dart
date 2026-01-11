import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:injectable/injectable.dart';

abstract class MenuRemoteDataSource {
  Future<Either<Failure, CatergoryFoodModel>> getProducts({String? foodName});
  Future<Either<Failure, List<FoodModel>>> getPopulartFoods();
  Future<Either<Failure, List<FoodModel>>> searchFoods({String? query});
  Future<Either<Failure, List<CategoryModel>>> getFoodsCategory();
}

@LazySingleton(as: MenuRemoteDataSource)
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

      if (res.data['code'] == 200) {
        final messageList = res.data['message'] as List;

        final categories = messageList.map((e) {
          return CategoryModel(
            id: e['id'] ?? '',
            name: e['name'] ?? '',
          );
        }).toList();

        return Right(categories);
      }

      return const Left(ServerFailure('Ошибка при получении категорий'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при получении категорий'));
    }
  }

  @override
  Future<Either<Failure, CatergoryFoodModel>> getProducts({String? foodName}) async {
    try {
      final res = await _dio.get(
        ApiConst.getAllFoodsByName,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
        queryParameters: {if (foodName != null) 'categoryName': foodName},
      );

      if (res.data['code'] == 200) {
        final messageList = res.data['message'] as List;
        final foods = messageList.map((e) => FoodModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(CatergoryFoodModel(foodModels: foods));
      }
      return const Left(ServerFailure('Ошибка при получении блюд'));
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
      if (res.data['code'] == 200) {
        final list = res.data['message']['foods'] as List;
        final foods = list.map((e) => FoodModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(foods);
      }
      return const Left(ServerFailure('Некорректный формат ответа сервера'));
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

      if (res.data['code'] == 200 && res.data != null) {
        final list = res.data['message'] as List;
        return Right(list.map((e) => FoodModel.fromJson(e)).toList());
      }
      return const Left(ServerFailure('Ошибка при получении популярных блюд'));
    } catch (e) {
      return Left(_handleError(e, 'Ошибка при получении популярных блюд'));
    }
  }

  Failure _handleError(Object e, String fallbackMessage) {
    if (e is DioException) {
      final msg = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : fallbackMessage;
      return ServerFailure(msg!);
    }
    return ServerFailure(fallbackMessage);
  }
}
