import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/features/map/presentation/widgets/widgets.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

@RoutePage()
class OrderMapPage extends StatefulWidget {
  final int totalPrice;
  final List<CartItemEntity> cart;
  const OrderMapPage({super.key, required this.cart, required this.totalPrice});

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage> {
  final _mapControllerCompleter = Completer<YandexMapController>();
  final _textController = TextEditingController();
  String? _address;
  Position? userLocation;
  late List<MapObject> _mapObjects;
  final List<PolygonMapObject> _polygons = [];
  double _lat = 0;
  double _long = 0;
  bool _firstLaunch = true;

  static const _kyrgyzstanBounds = BoundingBox(
    northEast: Point(latitude: 43.0019, longitude: 80.2754),
    southWest: Point(latitude: 39.1921, longitude: 69.2638),
  );

  @override
  void initState() {
    super.initState();
    _initPermission();
    _mapObjects = _getPolygonMapObjects();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chooseAddress, style: theme.textTheme.titleSmall),
      ),
      body: Stack(
        children: [
          MapWidget(
            mapObjects: _mapObjects,
            onCameraPositionChanged: _onCameraPositionChanged,
            onMapCreated: (controller) {
              _mapControllerCompleter.complete(controller);
              _fetchCurrentLocation();
            },
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Icon(Icons.location_on, size: 30, color: Colors.red),
          ),
        ],
      ),
      bottomSheet: BottomSheetWidget(
        theme: theme,
        address: _address,
        deliveryPrice: _calculateDeliveryPrice(),
        onAddressCardTap: _onAddressCardTap,
      ),
      floatingActionButton: FloatingActionButtonsWidget(
        theme: theme,
        onNavigationPressed: _fetchCurrentLocation,
        onSearchPressed: () => showMapSearchBottom(context, onSearch: _searchMap),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  void _onCameraPositionChanged(CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
    if (finished) {
      _updateAddressDetails(AppLatLong(
        latitude: cameraPosition.target.latitude,
        longitude: cameraPosition.target.longitude,
      ));
      _lat = cameraPosition.target.latitude;
      _long = cameraPosition.target.longitude;
    }
  }

  Future<void> _searchMap(String searchText) async {
    final searchResult = await YandexSearch.searchByText(
      searchText: searchText,
      searchOptions: const SearchOptions(),
      geometry: Geometry.fromBoundingBox(_kyrgyzstanBounds),
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
        _moveToCurrentLocation(point.latitude, point.longitude);
      } else {
        setState(() => _address = context.l10n.addressIsNotFounded);
        showToast('Адрес находится за пределами Кыргызстана', isError: true);
      }
    } else {
      showToast(context.l10n.addressIsNotFounded, isError: true);
    }
  }

  List<PolygonMapObject> _getPolygonMapObjects() {
    return Polygons.getPolygons().map((polygon) {
      return PolygonMapObject(
        mapId: MapObjectId('polygon_${polygon.id}'),
        polygon: Polygon(
          outerRing: LinearRing(
            points: polygon.coordinates.map((e) => Point(latitude: e.latitude, longitude: e.longitude)).toList(),
          ),
          innerRings: _polygons.isEmpty
              ? []
              : _polygons
                  .map((e) => LinearRing(
                        points: polygon.coordinates
                            .map((e) => Point(latitude: e.latitude, longitude: e.longitude))
                            .toList(),
                      ))
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

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<void> _fetchCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      setState(() {
        userLocation = position;
        _lat = position.latitude;
        _long = position.longitude;
      });
      await _moveToCurrentLocation(_lat, _long);
    } catch (e) {
      log("Error getting location: $e");
    }
  }

  Future<void> _moveToCurrentLocation(double latitude, double longitude) async {
    final controller = await _mapControllerCompleter.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: latitude, longitude: longitude),
          zoom: 16.0,
          azimuth: 0.0,
          tilt: 0.0,
        ),
      ),
    );

    if (!_isPointInKyrgyzstan(latitude, longitude)) {
      showToast('Адрес находится за пределами Кыргызстана', isError: true);
    }
  }

  Future<void> _updateAddressDetails(AppLatLong latLong) async {
    setState(() => _address = 'Поиск местоположения');

    try {
      final searchSessionData = await YandexSearch.searchByPoint(
        point: Point(latitude: latLong.latitude, longitude: latLong.longitude),
        searchOptions: const SearchOptions(),
      );

      final searchSessionResult = await searchSessionData.$2;

      if (searchSessionResult.items != null && searchSessionResult.items!.isNotEmpty) {
        final formattedAddress = searchSessionResult.items!.first.name;
        final point = searchSessionResult.items!.first.geometry.first.point;

        if (point != null && _isPointInKyrgyzstan(point.latitude, point.longitude)) {
          setState(() => _address = formattedAddress);
        } else {
          setState(() => _address = context.l10n.addressIsNotFounded);
          if (!_firstLaunch) {
            showToast('Адрес находится за пределами Кыргызстана', isError: true);
          }
        }
      } else {
        setState(() => _address = context.l10n.addressIsNotFounded);
      }
      _firstLaunch = false;
    } catch (error) {
      log(error.toString());
      setState(() => _address = context.l10n.addressIsNotFounded);
    }
  }

  bool _isPointInKyrgyzstan(double latitude, double longitude) {
    return latitude >= _kyrgyzstanBounds.southWest.latitude &&
        latitude <= _kyrgyzstanBounds.northEast.latitude &&
        longitude >= _kyrgyzstanBounds.southWest.longitude &&
        longitude <= _kyrgyzstanBounds.northEast.longitude;
  }

  void _onAddressCardTap() {
    if (_address == null || _address == context.l10n.addressIsNotFounded) {
      return;
    }

    final cartState = context.read<CartBloc>().state;
    int currentTotalItems = 0;
    if (cartState is CartLoaded) {
      currentTotalItems = cartState.totalItems;
    } else {
      log("Cart state is not CartLoaded when trying to get totalItems.");
    }

    context.read<OrderCubit>()
      ..changeAddress(_address!)
      ..changeAddressSearch(false)
      ..selectDeliveryPrice(_calculateDeliveryPrice());

    context.router.push(DeliveryFormRoute(
      totalPrice: widget.totalPrice,
      cart: widget.cart,
      dishCount: currentTotalItems,
    ));
  }

  double _calculateDeliveryPrice() {
    return MapHelper.isCoordinateInsidePolygons(_lat, _long, polygons: Polygons.getPolygons());
  }
}
