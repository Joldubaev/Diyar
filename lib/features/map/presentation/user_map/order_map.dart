import 'dart:async';
import 'dart:developer';
import 'dart:math' show asin, cos, sqrt;

import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/map/data/models/location_model.dart';
import 'package:diyar/features/map/data/repositories/location_repo.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/presentation/widgets/coordinats.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

@RoutePage()
class OrderMapPage extends StatefulWidget {
  const OrderMapPage({Key? key}) : super(key: key);

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final AddressRepository locationRepo = AddressRepository();
  final texControler = TextEditingController();
  String? address;
  Position? userLocation;
  double deliveryPrice = 0.0;
  double maxDeliveryPrice = 500;
  final double pricePerKm = 100;

  late final List<MapObject> mapObjects = _getPolygonMapObject(context);
  final MapObjectId mapObjectId = const MapObjectId('polygon');
  List<PolygonMapObject> polygons = [];

  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(context.l10n.chooseAddress,
              style: theme.textTheme.titleSmall)),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: YandexMap(
              mapObjects: mapObjects,
              onMapTap: (point) {},
              onCameraPositionChanged: (cameraPosition, reason, finished) {
                if (finished) {
                  updateAddressDetails(AppLatLong(
                    latitude: cameraPosition.target.latitude,
                    longitude: cameraPosition.target.longitude,
                  ));
                  lat = cameraPosition.target.latitude;
                  long = cameraPosition.target.longitude;
                }
              },
              onMapCreated: (controller) {
                mapControllerCompleter.complete(controller);
              },
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.location_on,
              size: 30,
              color: AppColors.red,
            ),
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        enableDrag: false,
        showDragHandle: true,
        backgroundColor: AppColors.white,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.25,
          minHeight: MediaQuery.of(context).size.height * 0.25,
        ),
        onClosing: () {},
        builder: (context) {
          for (int i = 0; i < Polygons.getPolygons().length; i++) {
            bool containsCoordinate =
                Polygons.getPolygons()[i].coordinates.contains(
                      Coordinate(latitude: lat, longitude: long),
                    );
            // ignore: avoid_print
            print(containsCoordinate);
          }
          return ListView(
            children: [
              ListTile(
                title: Text(
                    '${context.l10n.deliveryPrice}: ${isCoordinateInsidePolygons(lat, long, polygons: Polygons.getPolygons())} сом'),
              ),
              Card(
                child: ListTile(
                  title: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 72),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(address ?? context.l10n.addressIsNotFounded),
                    ),
                  ),
                  leading: const Icon(Icons.location_on, color: AppColors.red),
                  onTap: () {
                    AppAlert.showConfirmDialog(
                      context: context,
                      title: context.l10n.yourAddress,
                      content: Text(
                        '${context.l10n.areYouSureAddress}: $address',
                      ),
                      cancelText: context.l10n.no,
                      confirmText: context.l10n.yes,
                      cancelPressed: () => Navigator.pop(context),
                      confirmPressed: () {
                        Navigator.pop(context);
                        context.router.maybePop().then((value) {
                          context
                              .read<OrderCubit>()
                              .changeAddress(address ?? '');
                          context.read<OrderCubit>().selectDeliveryPrice(
                              isCoordinateInsidePolygons(lat, long,
                                  polygons: Polygons.getPolygons()));
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _fetchCurrentLocation();
          if (userLocation != null) {
            double distance = calculateDistance(userLocation!.latitude,
                userLocation!.longitude, 42.887931419030515, 74.66039095429396);
            setState(() {
              deliveryPrice = distance * pricePerKm;
            });

            log("Distance to restaurant: $distance km");
          } else {
            log("User location not available.");
          }
        },
        child: const Icon(Icons.navigation),
      ),
    );
  }

  List<PolygonMapObject> _getPolygonMapObject(BuildContext context) {
    return Polygons.getPolygons().map((polygon) {
      return PolygonMapObject(
        mapId: MapObjectId('polygon map object ${polygon.id}'),
        polygon: Polygon(
          outerRing: LinearRing(
              points: polygon.coordinates
                  .map((e) =>
                      Point(latitude: e.latitude, longitude: e.longitude))
                  .toList()),
          innerRings: polygons.isEmpty
              ? []
              : polygons
                  .map((e) => LinearRing(
                      points: polygon.coordinates
                          .map((e) => Point(
                              latitude: e.latitude, longitude: e.longitude))
                          .toList()))
                  .toList(),
        ),
        strokeColor: Colors.transparent,
      );
    }).toList();
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    final defLocation = BiskekLocation();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = position;
      });

      if (userLocation != null) {
        _moveToCurrentLocation(AppLatLong(
          latitude: userLocation!.latitude,
          longitude: userLocation!.longitude,
        ));
        lat = userLocation!.latitude;
        long = userLocation!.longitude;
      }
    } catch (e) {
      location = defLocation;
      log("Error getting location: $e");
    }
    location = defLocation;
    await updateAddressDetails(location);
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(AppLatLong appLatLong) async {
    (await mapControllerCompleter.future).moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.latitude,
            longitude: appLatLong.longitude,
          ),
        ),
      ),
    );
  }

  Future<void> updateAddressDetails(AppLatLong latLong) async {
    address = const Text('Поиск местоположения').data;
    setState(() {});
    LocationModel? data =
        await locationRepo.getLocationByAdress(latLong: latLong);
    address = data.response!.geoObjectCollection!.featureMember!.isEmpty
        ? 'unknown place'
        : data.response!.geoObjectCollection!.featureMember!.first.geoObject!
            .metaDataProperty!.geocoderMetaData!.address!.formatted
            .toString();

    if (userLocation != null) {
      double distance = calculateDistance(userLocation!.latitude,
          userLocation!.longitude, latLong.latitude, latLong.longitude);
      setState(() {
        deliveryPrice = distance * pricePerKm;
      });

      log("Distance to restaurant: $distance km");
    }

    setState(() {});
    log(' address: $address');
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((destinationLatitude - startLatitude) * p) / 2 +
        c(startLatitude * p) *
            c(destinationLatitude * p) *
            (1 - c((destinationLongitude - startLongitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  double isCoordinateInsidePolygons(double latitude, double longitude,
      {required List<DeliveryPolygon> polygons}) {
    for (var polygon in polygons) {
      if (isPointInPolygon(latitude, longitude, polygon.coordinates)) {
        return polygon.deliveryPrice;
      }
    }
    return maxDeliveryPrice;
  }

  bool isPointInPolygon(
      double latitude, double longitude, List<Coordinate> coordinates) {
    int intersectCount = 0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      double vertex1Lat = coordinates[i].latitude;
      double vertex1Long = coordinates[i].longitude;
      double vertex2Lat = coordinates[i + 1].latitude;
      double vertex2Long = coordinates[i + 1].longitude;
      // Check if the point is within the y-range of the edge
      if ((vertex1Long > longitude) != (vertex2Long > longitude)) {
        // Calculate the x-coordinate where the edge intersects with the vertical line of longitude
        double xIntersect = (vertex2Lat - vertex1Lat) *
                (longitude - vertex1Long) /
                (vertex2Long - vertex1Long) +
            vertex1Lat;
        // Check if the intersection point is above the given latitude
        if (latitude < xIntersect) {
          intersectCount++;
        }
      }
    }
    // If the number of intersections is odd, the point is inside the polygon
    return intersectCount % 2 == 1;
  }
}
