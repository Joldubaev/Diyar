import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/map/map.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class AddressSelectionPage extends StatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  final _mapControllerCompleter = Completer<YandexMapController>();
  String? _address;
  double _lat = 42.882004;
  double _long = 74.582748;
  double _currentZoom = 14.0;
  bool _isLoading = false;

  static const _chuiOblastBounds = BoundingBox(
    northEast: Point(latitude: 43.10, longitude: 76.00),
    southWest: Point(latitude: 42.40, longitude: 73.50),
  );

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
        title: Text('Выберите адрес доставки', style: theme.textTheme.titleSmall),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _skip,
        ),
        actions: [
          TextButton(
            onPressed: _skip,
            child: Text('Пропустить', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('address_selection_map'),
            mapObjects: const [],
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
                      Container(height: 1, width: 40, color: Colors.grey[300]),
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
      ),
      bottomSheet: _AddressSelectionBottomSheet(
        theme: theme,
        address: _address,
        isLoading: _isLoading,
        onSearchPressed: () => showMapSearchBottom(
          context,
          onSearch: (addressName, latitude, longitude) {
            if (latitude != null && longitude != null) {
              if (_isPointInBounds(latitude, longitude)) {
                _moveToLocation(latitude, longitude);
                setState(() {
                  _lat = latitude;
                  _long = longitude;
                  _address = addressName;
                });
              } else {
                showToast('Адрес находится за пределами зоны доставки', isError: true);
              }
            } else {
              _searchMap(addressName);
            }
          },
        ),
        onConfirm: _confirmAddress,
      ),
    );
  }

  void _skip() {
    context.router.replace(const MainHomeRoute());
  }

  Future<void> _confirmAddress() async {
    if (_address == null) return;

    final addressStorage = sl<AddressStorageService>();
    await addressStorage.saveAddress(_address!, _lat, _long);

    if (mounted) {
      context.router.replace(const MainHomeRoute());
    }
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

  Future<void> _initPermission() async {
    try {
      final locationService = sl<AppLocation>();
      if (!await locationService.checkPermission()) {
        await locationService.requestPermission();
      }
    } catch (_) {}
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() {
        _lat = position.latitude;
        _long = position.longitude;
      });
      await _moveToLocation(_lat, _long);
    } catch (_) {
      await _moveToLocation(_lat, _long);
    }
  }

  Future<void> _moveToLocation(double latitude, double longitude) async {
    final controller = await _mapControllerCompleter.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: latitude, longitude: longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  Future<void> _updateAddressDetails(AppLatLong latLong) async {
    setState(() {
      _isLoading = true;
      _address = null;
    });

    try {
      final searchSessionData = await YandexSearch.searchByPoint(
        point: Point(latitude: latLong.latitude, longitude: latLong.longitude),
        searchOptions: const SearchOptions(),
      );

      final result = await searchSessionData.$2;

      if (result.items != null && result.items!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _address = result.items!.first.name;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _address = 'Адрес не найден';
            _isLoading = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _address = 'Адрес не найден';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchMap(String searchText) async {
    String searchQuery = searchText.trim();
    final lowerQuery = searchQuery.toLowerCase();
    if (!lowerQuery.contains('чуйск') && !lowerQuery.contains('бишкек') && !lowerQuery.contains('bishkek')) {
      searchQuery = '$searchQuery Чуйская область';
    }

    final searchResult = await YandexSearch.searchByText(
      searchText: searchQuery,
      searchOptions: const SearchOptions(),
      geometry: Geometry.fromBoundingBox(_chuiOblastBounds),
    );

    final result = await searchResult.$2;
    if (!mounted) return;

    if (result.items == null || result.items!.isEmpty) {
      showToast('Адрес не найден', isError: true);
      return;
    }

    final firstItem = result.items!.first;
    if (firstItem.geometry.isEmpty) {
      showToast('Адрес не найден', isError: true);
      return;
    }

    final point = firstItem.geometry.first.point;
    if (point != null && _isPointInBounds(point.latitude, point.longitude)) {
      _moveToLocation(point.latitude, point.longitude);
      setState(() {
        _lat = point.latitude;
        _long = point.longitude;
        _address = firstItem.name;
      });
    } else {
      showToast('Адрес находится за пределами зоны доставки', isError: true);
    }
  }

  bool _isPointInBounds(double latitude, double longitude) {
    return latitude >= _chuiOblastBounds.southWest.latitude &&
        latitude <= _chuiOblastBounds.northEast.latitude &&
        longitude >= _chuiOblastBounds.southWest.longitude &&
        longitude <= _chuiOblastBounds.northEast.longitude;
  }

  Future<void> _zoomIn() async {
    final controller = await _mapControllerCompleter.future;
    _currentZoom += 1;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: _lat, longitude: _long),
          zoom: _currentZoom,
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
        ),
      ),
    );
  }
}

class _AddressSelectionBottomSheet extends StatelessWidget {
  final ThemeData theme;
  final String? address;
  final bool isLoading;
  final VoidCallback onSearchPressed;
  final VoidCallback onConfirm;

  const _AddressSelectionBottomSheet({
    required this.theme,
    required this.address,
    required this.isLoading,
    required this.onSearchPressed,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomInputWidget(
                filledColor: theme.colorScheme.surface,
                hintText: 'Поиск адреса',
                leading: const Icon(Icons.search),
                onTap: onSearchPressed,
                isReadOnly: true,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.place, color: theme.colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Город, улица и дом',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        isLoading
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Определяем адрес...', style: theme.textTheme.bodyMedium),
                                ],
                              )
                            : Text(
                                address ?? 'Переместите карту',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SubmitButtonWidget(
                onTap: (address != null && !isLoading) ? onConfirm : null,
                bgColor: theme.colorScheme.primary,
                title: 'Продолжить',
                textStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
