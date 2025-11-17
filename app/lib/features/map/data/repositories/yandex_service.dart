import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/data/models/price_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppLocation {
  Future<AppLatLong> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();
  Future<PriceModel> getDeliveryPrice(double latitude, double longitude);
}

@LazySingleton(as: AppLocation)
class LocationService implements AppLocation {
  final Dio dio;
  final SharedPreferences prefs;
  final defaultLocation = BiskekLocation();

  LocationService(this.dio, this.prefs);

  @override
  Future<AppLatLong> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((position) {
      return AppLatLong(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }).catchError((e) {
      return defaultLocation;
    });
  }

  @override
  Future<bool> requestPermission() async {
    return Geolocator.requestPermission()
        .then((value) => value == LocationPermission.always || value == LocationPermission.whileInUse)
        .catchError((e) => false);
  }

  @override
  Future<bool> checkPermission() async {
    return Geolocator.checkPermission()
        .then((value) => value == LocationPermission.always || value == LocationPermission.whileInUse)
        .catchError((e) => false);
  }

  @override
  Future<PriceModel> getDeliveryPrice(double latitude, double longitude) async {
    var token = prefs.getString(AppConst.accessToken) ?? '';
    return await dio
        .post(
      ApiConst.getDeliveryPrice,
      data: {'latitude': latitude, 'longitude': longitude},
      options: Options(headers: ApiConst.authMap(token)),
    )
        .then((value) {
      if (value.statusCode != 200) {
        return PriceModel(
          districtId: null,
          districtName: null,
          price: 500,
          yandexId: null,
        );
      }

      final data = value.data['message'] ?? value.data;
      return PriceModel.fromJson(data);
    }).catchError((e) => PriceModel(
              districtId: null,
              districtName: null,
              price: 500,
              yandexId: null,
            ));
  }
}

class AppLatLong {
  AppLatLong({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class BiskekLocation extends AppLatLong {
  BiskekLocation({
    super.latitude = 42.882004,
    super.longitude = 74.582748,
  });
}
