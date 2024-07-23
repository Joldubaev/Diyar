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
  final int totalPrice;
  final List<CartItemModel> cart;
  const OrderMapPage({super.key, required this.cart, required this.totalPrice});

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
  bool firstLaunch = true;

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
            height: MediaQuery.of(context).size.height - 350,
            child: YandexMap(
              mapObjects: mapObjects,
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
        constraints: const BoxConstraints(maxHeight: 300, minHeight: 300),
        onClosing: () {},
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.colorScheme.error,
                      border: Border.all(color: theme.colorScheme.onSurface)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${context.l10n.deliveryPrice}: ${MapHelper.isCoordinateInsidePolygons(lat, long, polygons: Polygons.getPolygons())} сом',
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.surface)),
                   
                    ],
                  )),
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
                        totalPrice: widget.totalPrice,
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
              onPressed: _fetchCurrentLocation,
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
            const SizedBox(height: 230),
          ],
        ),
      ),
    );
  }

  _searchMap(String searchText) async {
    final searchResult = await YandexSearch.searchByText(
      searchText: searchText,
      searchOptions: const SearchOptions(),
      geometry: Geometry.fromBoundingBox(
        const BoundingBox(
          northEast: Point(latitude: 43.0019, longitude: 80.2754),
          southWest: Point(latitude: 39.1921, longitude: 69.2638),
        ),
      ),
    );

    final result = await searchResult.$2;
    if (!mounted) return;
    if (result.items == null || result.items!.isEmpty) {
      showToast(context.l10n.addressIsNotFounded, isError: true);
      return;
    }
    final point = result.items!.first.geometry.first.point;
    if (point != null) {
      if (_isPointInKyrgyzstan(point.latitude, point.longitude)) {
        log(point.toString());
        _moveToCurrentLocation(point.latitude, point.longitude);
      } else {
        setState(() {
          address = context.l10n.addressIsNotFounded;
        });

        showToast('Адрес находится за пределами Кыргызстана', isError: true);
      }
    } else {
      showToast(context.l10n.addressIsNotFounded, isError: true);
    }
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
    const tilt = 0.0;
    const zoom = 16.0;
    const azimuth = 0.0;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: latitude, longitude: longitude),
          zoom: zoom,
          azimuth: azimuth,
          tilt: tilt,
        ),
      ),
    );

    if (!_isPointInKyrgyzstan(latitude, longitude)) {
      showToast('Адрес находится за пределами Кыргызстана', isError: true);
    }
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
        final point = searchSessionResult.items!.first.geometry.first.point;

        if (point != null &&
            _isPointInKyrgyzstan(point.latitude, point.longitude)) {
          setState(() {
            address = formattedAddress;
          });
        } else {
          setState(() {
            address = context.l10n.addressIsNotFounded;
          });
          if (!firstLaunch) {
            showToast(
              'Адрес находится за пределами Кыргызстана',
              isError: true,
            );
          }
        }
      } else {
        setState(() {
          address = context.l10n.addressIsNotFounded;
        });
      }
      firstLaunch = false;
    } catch (error) {
      log(error.toString());
      setState(() {
        address = context.l10n.addressIsNotFounded;
      });
    }
  }

  bool _isPointInKyrgyzstan(double latitude, double longitude) {
    return latitude >= 39.1921 &&
        latitude <= 43.0019 &&
        longitude >= 69.2638 &&
        longitude <= 80.2754;
  }

  @override
  void dispose() {
    textController.dispose();
    texControler.dispose();
    super.dispose();
  }
}
