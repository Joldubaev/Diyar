// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/utils/helper/helper.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/map/data/models/location_model.dart';
import 'package:diyar/features/map/data/repositories/location_repo.dart';
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
  final AddressRepository locationRepo = AddressRepository();
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
            context.l10n.chooseAddress,
            style: theme.textTheme.titleSmall,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () =>
                  showMapSearchBottom(context, onSearch: _searchMap),
            ),
          ]),
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
        showDragHandle: true,
        backgroundColor: AppColors.white,
        constraints: const BoxConstraints(maxHeight: 200, minHeight: 200),
        onClosing: () {},
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Text(
                '${context.l10n.deliveryPrice}: ${MapHelper.isCoordinateInsidePolygons(lat, long, polygons: Polygons.getPolygons())} сом',
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 5),
              Card(
                child: ListTile(
                  title: Text(
                    address ?? context.l10n.addressIsNotFounded,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.black),
                  ),
                  leading: const Icon(Icons.location_on, color: AppColors.red),
                  onTap: () {
                    if (address == null ||
                        address == context.l10n.addressIsNotFounded) return;
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
                        // change address in order cubit
                        context.read<OrderCubit>().changeAddress(address ?? '');
                        context.read<OrderCubit>().changeAddressSearch(false);

                        context.read<OrderCubit>().selectDeliveryPrice(
                            MapHelper.isCoordinateInsidePolygons(lat, long,
                                polygons: Polygons.getPolygons()));
                        // push to create order page
                        context.router.replace(
                          CreateOrderRoute(
                            cart: widget.cart,
                            dishCount: context.read<CartCubit>().dishCount,
                          ),
                        );
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
    );
  }

  /// Search for address on the map
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
    address = 'Поиск местоположения';
    setState(() {});
    LocationModel? data =
        await locationRepo.getLocationByCoordinates(latLong: latLong);

    if (data != null && data.response != null) {
      final featureMembers = data.response!.geoObjectCollection!.featureMember!;
      if (featureMembers.isNotEmpty) {
        final geoObject = featureMembers.first.geoObject!;
        final formattedAddress =
            geoObject.metaDataProperty?.geocoderMetaData?.address?.formatted;

        if (formattedAddress != null &&
            formattedAddress.contains('Кыргызстан')) {
          address = formattedAddress;
        } else {
          address = context.l10n.addressIsNotFounded;
        }
      } else {
        address = context.l10n.addressIsNotFounded;
      }
    } else {
      address = context.l10n.addressIsNotFounded;
    }

    if (userLocation != null) {
      double distance = MapHelper.calculateDistance(userLocation!.latitude,
          userLocation!.longitude, latLong.latitude, latLong.longitude);
      setState(() {
        deliveryPrice = distance * pricePerKm;
      });

      log("Distance to restaurant: $distance km");
    }

    setState(() {});
    log(' address: $address');
  }
}
