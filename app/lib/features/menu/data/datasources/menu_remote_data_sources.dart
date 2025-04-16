import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/menu/data/models/category_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<CategoryModel>> getProductsWithMenu({String? query});
  Future<List<FoodModel>> getPopulartFoods();
  Future<List<FoodModel>> searchFoods({String? name});
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;

  MenuRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CategoryModel>> getProductsWithMenu({String? query}) async {
    try {
      var res = await _dio.get(
        ApiConst.getCategories,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
        queryParameters: {if (query != null) 'foodName': query},
      );

      if (res.statusCode == 200) {
        if (res.data != null) {
          List<dynamic> list = res.data;

          return list.map((e) => CategoryModel.fromJson(e)).toList();
        }
        return [];
      } else {
        throw ServerException(
          'Error fetching categories',
          res.statusCode,
        );
      }
    } catch (e) {
      log("Error: $e");
      throw ServerException(
        'Error fetching categories',
        null,
      );
    }
  }

  @override
  Future<List<FoodModel>> searchFoods({String? name}) async {
    try {
      var res = await _dio.post(
        ApiConst.searchFoodsByName,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
        data: {if (name != null) 'foodName': name, 'page': 1, 'pageSize': 10},
      );
      if (res.statusCode == 200) {
        if (res.data != null) {
          List<dynamic> list = res.data;

          return (list.first['foods'] as List)
              .map((e) => FoodModel.fromJson(e))
              .toList();
        }
        return [];
      } else {
        log('Server responded with status code: ${res.statusCode}');
        throw ServerException(
          'Error fetching food data',
          res.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a non-2xx status code
        log('Status code: ${e.response?.statusCode}');
        log('Response data: ${e.response?.data}');
        log('Headers: ${e.response?.headers}');
      } else {
        // There was an error sending the request
        log('Error sending request: $e');
      }
      throw ServerException(
        'Error fetching food data',
        e.response?.statusCode,
      );
    } catch (e) {
      log('Unexpected error: $e');
      throw ServerException(
        'Error fetching food data',
        null,
      );
    }
  }

  @override
  Future<List<FoodModel>> getPopulartFoods() async {
    try {
      var res = await _dio.get(
        ApiConst.getPopularFoods,
        options: Options(headers: BaseHelper.getHeaders(isAuth: true)),
      );

      if (res.statusCode == 200) {
        if (res.data != null) {
          List<dynamic> list = res.data;
          return list.map((e) => FoodModel.fromJson(e)).toList();
        }
        return [];
      } else {
        throw ServerException(
          'Error fetching popular foods',
          res.statusCode,
        );
      }
    } catch (e) {
      log("Error: $e");
      throw ServerException(
        'Error fetching popular foods',
        null,
      );
    }
  }
}
