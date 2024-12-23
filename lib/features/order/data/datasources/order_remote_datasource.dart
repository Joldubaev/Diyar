import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/order/data/data.dart';
import 'package:diyar/features/order/data/models/distric_model.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../map/data/models/location_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<String>> getOrderHistory();
  Future<void> createOrder(CreateOrderModel order);
  Future<void> getPickupOrder(PickupOrderModel order);
  Future<Either<Failure, List<DistricModel>>> getDistricts( {String? search});
  Future<LocationModel> getGeoSuggestions({required String query});
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  OrderRemoteDataSourceImpl(this._dio, this._prefs);

  @override
  Future<LocationModel> getGeoSuggestions({required String query}) async {
    try {
      Map<String, dynamic> data = {
        'apikey': '1d3a039d-6ce6-44a2-9ad1-209ee24e3eb1',
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
        // Assuming LocationModel.fromJson is your method to parse JSON into your model
        return LocationModel.fromJson(json.decode(response.data));
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> getPickupOrder(PickupOrderModel order) async {
    try {
      var res = await _dio.post(
        ApiConst.getPickupOrder,
        data: order.toJson(),
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (![200, 201].contains(res.statusCode)) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> createOrder(CreateOrderModel order) async {
    try {
      var res = await _dio.post(
        ApiConst.createOrder,
        data: order.toJson(),
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );
      if (![200, 201].contains(res.statusCode)) {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> getOrderHistory() async {
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
        return List<String>.from(res.data['data']);
      } else {
        throw Exception('Failed to get order history');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Either<Failure, List<DistricModel>>> getDistricts({String? search}) async {
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
          final districts = List<DistricModel>.from(
            res.data.map((x) => DistricModel.fromJson(x)),
          );
          return Right(districts);
        } else {
          log('Unexpected data format: ${res.data}');
          return const Left(ServerFailure('Unexpected data format'));
        }
      } else {
        log('Error Message: ${res.data['message']}');
        return Left(ServerFailure(res.data['message'] ?? 'Unknown error'));
      }
    } catch (e, stacktrace) {
      log('Exception: $e');
      log('Stacktrace: $stacktrace');
      return const Left(ServerFailure('Failed to fetch districts'));
    }
  }
}
