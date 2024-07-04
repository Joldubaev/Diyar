import 'package:geolocator/geolocator.dart';

abstract class AppLocation {
  Future<AppLatLong> getCurrentLocation();
  Future<bool> requestPermission();
  Future<bool> checkPermission();
}

class LocationService implements AppLocation {
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
