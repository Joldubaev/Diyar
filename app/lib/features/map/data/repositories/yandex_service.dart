import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/injection_container.dart';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppLocation {
  Future<AppLatLong> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();
  Future<int> getDeliveryPrice(double latitude, double longitude);
}

class LocationService implements AppLocation {
  final Dio dio = sl<Dio>();
  final prefs = sl<SharedPreferences>();
  final defaultLocation = BiskekLocation();

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
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) => false);
  }

  @override
  Future<bool> checkPermission() async {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((e) => false);
  }

  @override
  Future<int> getDeliveryPrice(double latitude, double longitude) async {
    var token = prefs.getString(AppConst.accessToken) ?? '';
    return await dio
        .post(
      ApiConst.getDeliveryPrice,
      data: {'latitude': latitude, 'longitude': longitude},
      options: Options(headers: ApiConst.authMap(token)),
    )
        .then((value) {
      if (value.data['districtPrice'] == null) return 500;
      if (value.statusCode != 200) return 500;
      return value.data['districtPrice'];
    }).catchError((e) => 500);
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
