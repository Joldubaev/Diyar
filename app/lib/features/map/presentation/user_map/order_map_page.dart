import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/common/calculator/order_calculation_service.dart';
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

  static const _chuiOblastBounds = BoundingBox(
    northEast: Point(latitude: 43.10, longitude: 76.00),
    southWest: Point(latitude: 42.40, longitude: 73.50),
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
                key: const ValueKey('yandex_map'),
                mapObjects: _mapObjects,
                onCameraPositionChanged: _onCameraPositionChanged,
                onMapCreated: (controller) {
                  if (!_mapControllerCompleter.isCompleted) {
                    _mapControllerCompleter.complete(controller);
                    _fetchCurrentLocation();
                  }
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
        onSearchPressed: () => showMapSearchBottom(
          context,
          onSearch: (addressName, latitude, longitude) {
            log('[ON_SEARCH] Получен адрес: name="$addressName", lat=$latitude, lon=$longitude');

            if (latitude != null && longitude != null) {
              log('[ON_SEARCH] Координаты предоставлены, перемещение напрямую');
              // Если есть координаты, перемещаемся напрямую
              if (_isPointInKyrgyzstan(latitude, longitude)) {
                log('[ON_SEARCH] Координаты в пределах Кыргызстана');
                _moveToCurrentLocation(latitude, longitude);
                setState(() {
                  _lat = latitude;
                  _long = longitude;
                  _address = addressName;
                });
                log('[ON_SEARCH] Состояние обновлено: lat=$_lat, lon=$_long, address="$_address"');
                context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
              } else {
                log('[ON_SEARCH] Координаты за пределами Кыргызстана');
                showToast('Адрес находится за пределами Кыргызстана', isError: true);
              }
            } else {
              log('[ON_SEARCH] Координаты не предоставлены, выполнение поиска по названию');
              // Если координат нет, делаем поиск по названию
              _searchMap(addressName);
            }
          },
        ),
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
    log('[SEARCH_MAP] Начало поиска адреса на карте: "$searchText"');
    String searchQuery = searchText.trim();
    final lowerQuery = searchQuery.toLowerCase();
    if (!lowerQuery.contains('чуйск') && !lowerQuery.contains('бишкек') && !lowerQuery.contains('bishkek')) {
      searchQuery = '$searchQuery Чуйская область';
      log('[SEARCH_MAP] Добавлена "Чуйская область" к запросу. Итоговый запрос: "$searchQuery"');
    } else {
      log('[SEARCH_MAP] Запрос уже содержит регион. Итоговый запрос: "$searchQuery"');
    }

    log('[SEARCH_MAP] Вызов YandexSearch.searchByText с запросом: "$searchQuery"');

    final searchResult = await YandexSearch.searchByText(
      searchText: searchQuery,
      searchOptions: const SearchOptions(),
      geometry: Geometry.fromBoundingBox(_chuiOblastBounds),
    );

    log('[SEARCH_MAP] Получен ответ от YandexSearch, ожидание результата...');
    final result = await searchResult.$2;

    if (!mounted) {
      log('[SEARCH_MAP] Context не mounted, прерывание');
      return;
    }

    if (result.items == null || result.items!.isEmpty) {
      log('[SEARCH_MAP] Результаты не найдены');
      showToast(context.l10n.addressIsNotFounded, isError: true);
      return;
    }

    log('[SEARCH_MAP] Найдено результатов: ${result.items!.length}');
    for (int i = 0; i < result.items!.length; i++) {
      log('[SEARCH_MAP] Результат ${i + 1}: name="${result.items![i].name}"');
    }

    // Ищем наиболее подходящий результат:
    // приоритет отдаётся результату, чьё имя содержит часть поискового запроса
    // (чтобы не получить "Бишкек" вместо "проспект Жибек-Жолу")
    final lowerSearchText = searchText.toLowerCase();
    final firstItem = result.items!.firstWhere(
      (item) {
        final name = item.name.toLowerCase();
        // Проверяем, содержит ли результат ключевые слова из исходного запроса
        // (исключая общие слова вроде "бишкек")
        final keywords = lowerSearchText
            .replaceAll('бишкек', '')
            .replaceAll('bishkek', '')
            .replaceAll(',', ' ')
            .split(' ')
            .where((w) => w.trim().length > 2)
            .toList();
        return keywords.any((keyword) => name.contains(keyword));
      },
      orElse: () => result.items!.first,
    );
    log('[SEARCH_MAP] Выбранный результат: name="${firstItem.name}"');

    if (firstItem.geometry.isEmpty) {
      log('[SEARCH_MAP] Ошибка: geometry пустой');
      showToast(context.l10n.addressIsNotFounded, isError: true);
      return;
    }

    final point = firstItem.geometry.first.point;
    if (point != null) {
      log('[SEARCH_MAP] Координаты найдены: lat=${point.latitude}, lon=${point.longitude}');

      if (_isPointInKyrgyzstan(point.latitude, point.longitude)) {
        log('[SEARCH_MAP] Координаты в пределах Кыргызстана, перемещение карты...');
        _moveToCurrentLocation(point.latitude, point.longitude);

        setState(() {
          _lat = point.latitude;
          _long = point.longitude;
          _address = firstItem.name; // Обновляем адрес из результата поиска
        });

        log('[SEARCH_MAP] Состояние обновлено: lat=$_lat, lon=$_long, address="$_address"');

        context.read<UserMapCubit>().getDeliveryPrice(_lat, _long);
        log('[SEARCH_MAP] Запрос цены доставки отправлен');
      } else {
        log('[SEARCH_MAP] Координаты за пределами Кыргызстана');
        setState(() => _address = context.l10n.addressIsNotFounded);
        showToast('Адрес находится за пределами Кыргызстана', isError: true);
      }
    } else {
      log('[SEARCH_MAP] Ошибка: point равен null');
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
    log('[MOVE_CAMERA] Начало перемещения камеры: lat=$latitude, lon=$longitude');

    final controller = await _mapControllerCompleter.future;
    log('[MOVE_CAMERA] Контроллер карты получен');

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

    log('[MOVE_CAMERA] Команда перемещения камеры отправлена');

    if (!_isPointInKyrgyzstan(latitude, longitude)) {
      log('[MOVE_CAMERA] Предупреждение: точка за пределами Кыргызстана');
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
    return latitude >= _chuiOblastBounds.southWest.latitude &&
        latitude <= _chuiOblastBounds.northEast.latitude &&
        longitude >= _chuiOblastBounds.southWest.longitude &&
        longitude <= _chuiOblastBounds.northEast.longitude;
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
