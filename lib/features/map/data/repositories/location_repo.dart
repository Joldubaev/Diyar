import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/features/map/data/models/location_model.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';

class AddressRepository {
  Future<LocationModel> getLocationByAdress({required AppLatLong latLong}) async {
    try {
      Map<String, dynamic> data = {
        'apikey': AppConst.getLocations,
        'geocode': '${latLong.longitude},${latLong.latitude}',
        'format': 'json',
        'lang': 'ru_RU',
        'results': '1',
      };
      Dio dio = Dio();
      final response = await dio.get(
        'https://geocode-maps.yandex.ru/1.x/',
        queryParameters: data,
      );
      log('response: ${response.data}');

      return LocationModel.fromJson(response.data);
    } catch (e) {
      log('error: $e');
      rethrow;
    }
  }
  // Future<LocationModel> getLocations({required AppLatLong latLong}) async {
  //   try {
  //     final response = await dio.get(
  //       ApiConst.getLocations(
  //         apiKey: AppConst.getLocations,
  //         lat: latLong.latitude.toString(),
  //         lang: latLong.longitude.toString(),
  //       ),
  //     );
  //     return LocationModel.fromJson(response.data);
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
