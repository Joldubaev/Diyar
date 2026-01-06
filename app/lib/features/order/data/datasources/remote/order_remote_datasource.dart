import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/order/data/models/model.dart';
import 'package:diyar/features/order/data/datasources/remote/order_remote_datasource_helpers.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, List<String>>> getOrderHistory();
  Future<Either<Failure, String>> createOrder(CreateOrderModel order);
  Future<Either<Failure, List<DistrictDataModel>>> getDistricts({String? search});
  Future<Either<Failure, LocationModel>> getGeoSuggestions({required String query});
}

@LazySingleton(as: OrderRemoteDataSource)
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

      return OrderRemoteDataSourceHelpers.handleGeoSuggestionsResponse(
        response.data,
        response.statusCode,
      );
    } catch (e, stacktrace) {
      log('Error in getGeoSuggestions: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return OrderRemoteDataSourceHelpers.handleDioException<LocationModel>(e, 'geo suggestions');
      }
      return OrderRemoteDataSourceHelpers.handleGenericException<LocationModel>(e, 'geo suggestions');
    }
  }

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderModel order) async {
    try {
      final jsonData = order.toJsonFlat();
      log('Sending order to API: userName="${jsonData['userName']}", userPhone="${jsonData['userPhone']}"');
      log('Full order JSON: $jsonData');
      log('API endpoint: ${ApiConst.createOrder}');
      log('Auth token: ${_prefs.getString(AppConst.accessToken)?.substring(0, 20)}...');

      var res = await _dio.post(
        ApiConst.createOrder,
        data: jsonData,
        options: Options(
          headers: ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      log('Response status: ${res.statusCode}');
      log('Response data: ${res.data}');

      return OrderRemoteDataSourceHelpers.handleCreateOrderResponse(
        res.data,
        res.statusCode,
      );
    } catch (e, stacktrace) {
      log('Error in createOrder: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return OrderRemoteDataSourceHelpers.handleDioException<String>(e, 'order creation');
      }
      return OrderRemoteDataSourceHelpers.handleGenericException<String>(e, 'order creation');
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
      return OrderRemoteDataSourceHelpers.handleOrderHistoryResponse(
        res.data,
        res.statusCode,
      );
    } catch (e, stacktrace) {
      log('Error in getOrderHistory: $e');
      log('Stacktrace: $stacktrace');
      if (e is DioException) {
        return OrderRemoteDataSourceHelpers.handleDioException<List<String>>(e, 'order history');
      }
      return OrderRemoteDataSourceHelpers.handleGenericException<List<String>>(e, 'order history');
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

      return OrderRemoteDataSourceHelpers.handleDistrictsResponse(
        res.data,
        res.statusCode,
      );
    } catch (e, stacktrace) {
      log('Exception: $e');
      log('Stacktrace: $stacktrace');
      return const Left(ServerFailure('Failed to fetch districts', null));
    }
  }
}

