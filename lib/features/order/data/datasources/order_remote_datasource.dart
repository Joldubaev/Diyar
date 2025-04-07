import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:diyar/core/error/failure.dart';
import 'package:diyar/features/order/data/data.dart';
import 'package:diyar/features/order/data/models/create_payment_model.dart';
import 'package:diyar/features/order/data/models/distric_model.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../map/data/models/location_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<String>> getOrderHistory();
  Future<Either<Failure, String>> createOrder(CreateOrderModel order);
  Future<Either<Failure, String>> getPaymnent(PaymentModel order);
  Future<Either<Failure, void>> getPickupOrder(PickupOrderModel order);
  Future<Either<Failure, List<DistricModel>>> getDistricts({String? search});
  Future<LocationModel> getGeoSuggestions({required String query});
}

class OrderRemoteDataSourceImpl extends OrderRemoteDataSource {
  final Dio _dio;
  final SharedPreferences _prefs;

  OrderRemoteDataSourceImpl(this._dio, this._prefs);

@override
Future<Either<Failure, String>> getPaymnent(PaymentModel order) async {
  try {
    final res = await _dio.post(
      ApiConst.getPayment,
      data: order.toJson(),
      options: Options(
        headers: ApiConst.authMap(
          _prefs.getString(AppConst.accessToken) ?? '',
        ),
      ),
    );

    log("✅ [PAYMENT CREATED] Ответ: ${res.data}");

    if (![200, 201].contains(res.statusCode)) {
      return Left(ServerFailure("❌ Ошибка платежа: ${res.statusCode}, response: ${res.data}"));
    }

    if (res.data is! Map<String, dynamic>) {
      return Left(ServerFailure("❌ Ответ не в формате JSON: ${res.data}"));
    }

    final data = res.data["data"];
    if (data == null || data["payFormUrl"] == null) {
      return Left(ServerFailure("❌ Ответ не содержит `payFormUrl`: ${res.data}"));
    }

    final payFormUrl = data["payFormUrl"];
    log("✅ [PAYMENT SUCCESS] Ссылка: $payFormUrl");

    return Right(payFormUrl);
  } catch (e, stackTrace) {
    log("❌ [ERROR] Ошибка при оплате: $e", error: e, stackTrace: stackTrace);
    return Left(ServerFailure("❌ Ошибка при оплате: $e"));
  }
}


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

      final response = await _dio.get(
        'https://geocode-maps.yandex.ru/1.x/',
        queryParameters: data,
      );

      if (response.statusCode == 200) {
        return LocationModel.fromJson(json.decode(response.data));
      } else {
        throw Exception('Не удалось загрузить геосуггестии');
      }
    } catch (e) {
      log("❌ Ошибка при геосуггестии: $e");
      rethrow;
    }
  }

  @override
  Future<Either<Failure, void>> getPickupOrder(PickupOrderModel order) async {
    try {
      final res = await _dio.post(
        ApiConst.getPickupOrder,
        data: order.toJson(),
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      if (![200, 201].contains(res.statusCode)) {
        return Left(ServerFailure("Ошибка создания самовывоза: ${res.data}"));
      }

      log("✅ Самовывоз успешно создан");
      return const Right(null);
    } catch (e) {
      log("❌ Ошибка при самовывозе: $e");
      return Left(ServerFailure("Ошибка при самовывозе: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> createOrder(CreateOrderModel order) async {
    try {
      final res = await _dio.post(
        ApiConst.createOrder,
        data: order.toJson(),
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      log("✅ [ORDER CREATED] Полный ответ: ${res.data}");

      if (![200, 201].contains(res.statusCode)) {
        return Left(
            ServerFailure("Ошибка создания заказа: статус ${res.statusCode}"));
      }

      if (res.data is! Map<String, dynamic>) {
        return Left(ServerFailure("Ответ не в формате JSON: ${res.data}"));
      }

      final orderNumber = res.data["orderNumber"];

      if (orderNumber == null || orderNumber.toString().trim().isEmpty) {
        return Left(
            ServerFailure("orderNumber пустой или некорректный: $orderNumber"));
      }

      log("✅ [ORDER SUCCESS] Заказ создан: #$orderNumber");
      return Right(orderNumber.toString());
    } catch (e, stackTrace) {
      log("❌ [ERROR] Ошибка при создании заказа: $e",
          error: e, stackTrace: stackTrace);
      return Left(ServerFailure("Ошибка при создании заказа: $e"));
    }
  }

  @override
  Future<List<String>> getOrderHistory() async {
    try {
      final res = await _dio.get(
        ApiConst.getOrderHistory,
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      if (res.statusCode == 200) {
        return List<String>.from(res.data['data']);
      } else {
        throw Exception('Ошибка загрузки истории заказов');
      }
    } catch (e) {
      log("❌ Ошибка загрузки истории заказов: $e");
      throw Exception(e);
    }
  }

  @override
  Future<Either<Failure, List<DistricModel>>> getDistricts(
      {String? search}) async {
    try {
      final res = await _dio.get(
        ApiConst.getDistricts,
        queryParameters: {if (search != null) 'foodName': search},
        options: Options(
          headers:
              ApiConst.authMap(_prefs.getString(AppConst.accessToken) ?? ''),
        ),
      );

      if (res.statusCode == 200) {
        if (res.data is List) {
          final districts = List<DistricModel>.from(
            res.data.map((x) => DistricModel.fromJson(x)),
          );
          return Right(districts);
        } else {
          return Left(ServerFailure('Неверный формат данных'));
        }
      } else {
        return Left(ServerFailure(res.data['message'] ?? 'Неизвестная ошибка'));
      }
    } catch (e) {
      log("❌ Ошибка при получении районов: $e");
      return Left(ServerFailure('Ошибка при получении районов'));
    }
  }
}
