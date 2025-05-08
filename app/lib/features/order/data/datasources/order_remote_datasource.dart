import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, List<String>>> getOrderHistory();
  Future<Either<Failure, Unit>> createOrder(CreateOrderModel order);
  Future<Either<Failure, List<DistrictDataModel>>> getDistricts({String? search});
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query});
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  OrderRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query}) async {
    try {
      Map<String, dynamic> data = {
        'apikey': AppConst.yandexMapKey,
        'geocode': query,
        'format': 'json',
        'lang': 'ru_RU',
        'results': '5',
      };

      Dio dio = Dio();
      final response = await dio.get(
        'https://geocode-maps.yandex.ru/1.x/',
        queryParameters: data,
      );

      if (response.statusCode == 200) {
        log('Response: ${response.data}');
        try {
          final model = LocationModel.fromJson(response.data is String ? json.decode(response.data) : response.data);
          return Right(model);
        } catch (e, stacktrace) {
          log('Error parsing GeoSuggestions: $e');
          log('Stacktrace: $stacktrace');
          return Left(ServerFailure('Failed to parse geo suggestions: ${e.toString()}', null));
        }
      } else {
        log('Failed to load suggestions: ${response.statusCode} ${response.statusMessage}');
        return Left(ServerFailure(response.statusMessage ?? 'Failed to load suggestions', response.statusCode));
      }
    } catch (e, stacktrace) {
      log('Error in getGeoSuggestions: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Network error in geo suggestions', e.response?.statusCode));
      }
      return Left(ServerFailure('Exception in geo suggestions: ${e.toString()}', null));
    }
  }


  @override
  Future<Either<Failure, Unit>> createOrder(CreateOrderModel order) async {
    try {
      var res = await _dio.post(
        ApiConst.createOrder,
        data: order.toJson(),
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if ([200, 201].contains(res.statusCode)) {
        return const Right(unit);
      } else {
        log('Failed to create order: ${res.statusCode} ${res.data}');
        return Left(ServerFailure(res.data?['message']?.toString() ?? 'Failed to create order', res.statusCode));
      }
    } catch (e, stacktrace) {
      log('Error in createOrder: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Network error during order creation', e.response?.statusCode));
      }
      return Left(ServerFailure('Exception during order creation: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getOrderHistory() async {
    try {
      var res = await _dio.get(
        ApiConst.getOrderHistory,
        options: Options(
          headers: ApiConst.authMap(
            _prefs.getString(AppConst.accessToken) ?? '',
          ),
        ),
      );
      if (res.statusCode == 200) {
        if (res.data != null && res.data['data'] is List) {
          final history = List<String>.from(res.data['data']);
          return Right(history);
        } else {
          log('Unexpected data format for order history: ${res.data}');
          return const Left(ServerFailure('Unexpected data format for order history', null));
        }
      } else {
        log('Failed to get order history: ${res.statusCode} ${res.data}');
        return Left(ServerFailure(res.data?['message']?.toString() ?? 'Failed to get order history', res.statusCode));
      }
    } catch (e, stacktrace) {
      log('Error in getOrderHistory: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Network error fetching order history', e.response?.statusCode));
      }
      return Left(ServerFailure('Exception fetching order history: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, List<DistrictDataModel>>> getDistricts({String? search}) async {
    try {
      final res = await _dio.get(
        ApiConst.getDistricts,
        queryParameters: {if (search != null) 'foodName': search},
        options: Options(
          headers: ApiConst.authMap(
            _prefs.getString(AppConst.accessToken) ?? '',
          ),
        ),
      );

      if (res.statusCode == 200) {
        log('Response: ${res.data}');

        if (res.data is List) {
          final districts = List<DistrictDataModel>.from(
            res.data.map((x) => DistrictDataModel.fromJson(x)),
          );
          return Right(districts);
        } else {
          log('Unexpected data format: ${res.data}');
          return const Left(ServerFailure('Unexpected data format', null));
        }
      } else {
        log('Error Message: ${res.data['message']}');
        return Left(ServerFailure(res.data['message'] ?? 'Unknown error', res.statusCode));
      }
    } catch (e, stacktrace) {
      log('Exception: $e');
      log('Stacktrace: $stacktrace');
      return const Left(ServerFailure('Failed to fetch districts', null));
    }
  }
}
