import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/utils/helper/helper.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/presentation/widgets/coordinats.dart';
import 'package:diyar/features/map/presentation/widgets/widgets.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

@RoutePage()
class OrderMapPage extends StatefulWidget {
  final List<CartItemModel> cart;
  const OrderMapPage({super.key, required this.cart});

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final TextEditingController textController = TextEditingController();
  final texControler = TextEditingController();
  String? address;
  Position? userLocation;
  double deliveryPrice = 0.0;
  double maxDeliveryPrice = 500;
  final double pricePerKm = 100;

  late final List<MapObject> mapObjects = _getPolygonMapObject(context);
  final MapObjectId mapObjectId = const MapObjectId('polygon');
  List<PolygonMapObject> polygons = [];
  List<String> suggestions = [];

  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();
    _initPermission();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(context.l10n.chooseAddress,
              style: theme.textTheme.titleSmall)),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
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
                _fetchCurrentLocation();
              },
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Icon(Icons.location_on,
                  size: 30, color: theme.colorScheme.error)),
        ],
      ),
      bottomSheet: BottomSheet(
        showDragHandle: true,
        backgroundColor: theme.colorScheme.surface,
        constraints: const BoxConstraints(maxHeight: 250, minHeight: 250),
        onClosing: () {},
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              Text(
                  '${context.l10n.deliveryPrice}: ${MapHelper.isCoordinateInsidePolygons(lat, long, polygons: Polygons.getPolygons())} сом',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurface)),
              const SizedBox(height: 10),
              Card(
                color: theme.colorScheme.primary,
                child: ListTile(
                  title: Text(address ?? context.l10n.addressIsNotFounded,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onTertiaryFixed,
                          fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: theme.colorScheme.onTertiaryFixed),
                  onTap: () {
                    if (address == null ||
                        address == context.l10n.addressIsNotFounded) return;
                    context.read<OrderCubit>().changeAddress(address ?? '');
                    context.read<OrderCubit>().changeAddressSearch(false);

                    context.read<OrderCubit>().selectDeliveryPrice(
                        MapHelper.isCoordinateInsidePolygons(lat, long,
                            polygons: Polygons.getPolygons()));
                    context.router.push(DeliveryFormRoute(
                        cart: widget.cart,
                        dishCount: context.read<CartCubit>().dishCount));
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 1,
              onPressed: () async {
                _fetchCurrentLocation();
                if (userLocation != null) {
                  double distance = MapHelper.calculateDistance(
                      userLocation!.latitude,
                      userLocation!.longitude,
                      42.887931419030515,
                      74.66039095429396);
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
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 2,
              backgroundColor: theme.colorScheme.onTertiaryFixed,
              onPressed: () async {
                showMapSearchBottom(context, onSearch: _searchMap);
              },
              child: Icon(Icons.search,
                  color: theme.colorScheme.onSurface, size: 40),
            ),
            const SizedBox(height: 170),
          ],
        ),
      ),
    );
  }

  _searchMap(p0) async => await YandexSearch.searchByText(
          searchText: p0,
          searchOptions: const SearchOptions(),
          geometry: Geometry.fromBoundingBox(
            const BoundingBox(
              northEast: Point(latitude: 42.8764, longitude: 74.6072),
              southWest: Point(latitude: 42.7919, longitude: 74.4317),
            ),
          )).then((value) {
        value.$2.then((value) {
          if (value.items == null) return;
          if (value.items?.first.geometry.first.point != null) {
            final point = value.items!.first.geometry.first.point;
            log(point.toString());
            _moveToCurrentLocation(
              point!.latitude,
              point.longitude,
            );
          } else {
            showToast(context.l10n.addressIsNotFounded, isError: true);
          }
        });
      });

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
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = position;
        lat = position.latitude;
        long = position.longitude;
      });

      log("User location: ($lat, $long)");
      await _moveToCurrentLocation(lat, long);
    } catch (e) {
      log("Error getting location: $e");
    }
  }

  Future<void> _moveToCurrentLocation(double latitude, double longitude) async {
    final controller = await mapControllerCompleter.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: latitude, longitude: longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Future<void> updateAddressDetails(AppLatLong latLong) async {
    setState(() {
      address = 'Поиск местоположения';
    });

    try {
      final searchSessionData = await YandexSearch.searchByPoint(
        point: Point(latitude: latLong.latitude, longitude: latLong.longitude),
        searchOptions: const SearchOptions(),
      );

      final searchSessionResult = await searchSessionData.$2;

      if (searchSessionResult.items != null &&
          searchSessionResult.items!.isNotEmpty) {
        final formattedAddress = searchSessionResult.items!.first.name;
        setState(() {
          address = formattedAddress;
        });
      } else {
        setState(() {
          address = context.l10n.addressIsNotFounded;
        });
      }

      if (userLocation != null) {
        double distance = MapHelper.calculateDistance(
          userLocation!.latitude,
          userLocation!.longitude,
          latLong.latitude,
          latLong.longitude,
        );
        setState(() {
          deliveryPrice = distance * pricePerKm;
        });

        log("Distance to restaurant: $distance km");
      }
    } catch (e) {
      setState(() {
        address = context.l10n.addressIsNotFounded;
      });
      log('Error updating address details: $e');
    }

    log('Address: $address');
  }
}
