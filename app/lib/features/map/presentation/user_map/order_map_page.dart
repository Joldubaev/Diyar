import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/common/calculiator/order_calculation_service.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/pages/cart_price_calculator.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

@RoutePage()
class OrderMapPage extends StatefulWidget {
  final int totalPrice;
  final List<CartItemEntity> cart;
  final int? dishCount;
  const OrderMapPage({
    super.key,
    required this.cart,
    required this.totalPrice,
    this.dishCount,
  });

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
  double _currentZoom = 14.0;
  double _deliveryPrice = 0;

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
      body: BlocConsumer<UserMapCubit, UserMapState>(
        listener: (context, state) {
          if (state is GetDistrictPriceLoaded) {
            setState(() {
              _deliveryPrice = state.priceModel.price?.toDouble() ?? 0;
            });
          } else if (state is GetDelPriceError) {
            setState(() {
              _deliveryPrice = MapHelper.isCoordinateInsidePolygons(_lat, _long, polygons: Polygons.getPolygons());
            });
          }
        },
        builder: (context, state) {
          return Stack(
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
              Align(
                alignment: const Alignment(0.95, -0.3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Zoom Controls
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.black87),
                            onPressed: _zoomIn,
                            iconSize: 28,
                            padding: const EdgeInsets.all(12),
                          ),
                          Container(
                            height: 1,
                            width: 40,
                            color: Colors.grey[300],
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.black87),
                            onPressed: _zoomOut,
                            iconSize: 28,
                            padding: const EdgeInsets.all(12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Location Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.navigation_outlined, color: Colors.black87),
                        onPressed: _fetchCurrentLocation,
                        iconSize: 28,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: BottomSheetWidget(
        theme: theme,
        address: _address,
        deliveryPrice: _deliveryPrice,
        onAddressCardTap: _onAddressCardTap,
        onSearchPressed: () => showMapSearchBottom(context, onSearch: _searchMap),
      ),
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

      context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
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

        setState(() {
          _lat = point.latitude;
          _long = point.longitude;
        });

        context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
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
    try {
      final locationService = sl<AppLocation>();
      if (!await locationService.checkPermission()) {
        final granted = await locationService.requestPermission();
        if (!granted) {
          // Если разрешение не дано, используем координаты Бишкека
          setState(() {
            _lat = 42.882004;
            _long = 74.582748;
          });
        }
      }
    } catch (e) {
      setState(() {
        _lat = 42.882004;
        _long = 74.582748;
      });
    }
  }

  final LocationSettings locationSettings = const LocationSettings(
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

      if (mounted) {
        context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
      }
    } catch (e) {
      setState(() {
        _lat = 42.882004;
        _long = 74.582748;
      });

      await _moveToCurrentLocation(_lat, _long);

      if (mounted) {
        context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
      }
    }
  }

  Future<void> _moveToCurrentLocation(double latitude, double longitude) async {
    final controller = await _mapControllerCompleter.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: latitude, longitude: longitude),
          zoom: 14.0,
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
        setState(() => _address = formattedAddress);
      } else {
        setState(() => _address = context.l10n.addressIsNotFounded);
      }
    } catch (error) {
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

    // Пересчитываем totalPrice с учетом containerPrice
    final calculationService = sl<OrderCalculationService>();
    final priceCalculator = CartPriceCalculator(calculationService);

    // Получаем процент скидки из HomeContentCubit, если доступен
    double discountPercentage = 0.0;
    final homeContentState = context.maybeRead<HomeContentCubit>()?.state;
    if (homeContentState is GetSalesLoaded && homeContentState.sales.isNotEmpty) {
      discountPercentage = priceCalculator.getDiscountPercentage(homeContentState.sales);
    }

    // Рассчитываем правильную цену с учетом containerPrice
    final priceResult = priceCalculator.calculatePrices(
      cartItems: widget.cart,
      discountPercentage: discountPercentage,
    );
    final calculatedTotalPrice = priceResult.subtotalPrice.toInt();

    // Получаем данные пользователя из ProfileCubit
    final profileCubit = context.read<ProfileCubit>();
    final user = profileCubit.user;

    context.router.push(DeliveryFormRoute(
        totalPrice: calculatedTotalPrice,
        cart: widget.cart,
        dishCount: widget.dishCount ?? 0,
        address: _address!,
        deliveryPrice: _deliveryPrice,
        initialUserName: user?.userName,
        initialUserPhone: user?.phone));
  }

  Future<void> _zoomIn() async {
    final controller = await _mapControllerCompleter.future;
    _currentZoom += 1;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: _lat, longitude: _long),
          zoom: _currentZoom,
          azimuth: 0.0,
          tilt: 0.0,
        ),
      ),
    );
  }

  Future<void> _zoomOut() async {
    final controller = await _mapControllerCompleter.future;
    _currentZoom -= 1;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: _lat, longitude: _long),
          zoom: _currentZoom,
          azimuth: 0.0,
          tilt: 0.0,
        ),
      ),
    );
  }
}
