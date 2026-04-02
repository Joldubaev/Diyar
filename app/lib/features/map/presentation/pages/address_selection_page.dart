import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo/geo.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/map/map.dart';

@RoutePage()
class AddressSelectionPage extends StatefulWidget {
  const AddressSelectionPage({super.key});

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  final _mapControllerCompleter = Completer<YandexMapController>();
  static const double _defaultZoom = 19.0;
  static const double _minZoom = 12.0;
  static const double _maxZoom = 21.0;

  double _currentZoom = _defaultZoom;
  List<GeoPoint> _serviceZoneBoundary = const [];

  @override
  void initState() {
    super.initState();
    _initPermission();
    _loadServiceZone();
  }

  Future<void> _loadServiceZone() async {
    final boundary = await MapHelper.getServiceZoneBoundary();
    if (mounted) setState(() => _serviceZoneBoundary = boundary);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => di.sl<AddressSelectionCubit>(),
      child: BlocConsumer<AddressSelectionCubit, AddressSelectionState>(
        listenWhen: (prev, curr) =>
            curr is AddressSelectionConfirmed || curr is AddressSelectionMoveTo || curr is AddressSelectionSearchError,
        listener: (context, state) async {
          if (state is AddressSelectionConfirmed) {
            final didPop = await context.router.maybePop();
            if (!didPop && context.mounted) {
              context.router.replace(const MainHomeRoute());
            }
            return;
          }
          if (state is AddressSelectionMoveTo) {
            _moveToLocation(state.latitude, state.longitude);
            return;
          }
          if (state is AddressSelectionSearchError) {
            showToast(state.message, isError: true);
          }
        },
        builder: (context, state) {
          final data = state is AddressSelectionData ? state : null;
          final address = data?.address;
          final isLoading = data?.isLoading ?? false;
          final deliveryPrice = data?.deliveryPrice ?? 0.0;
          final latitude = data?.latitude ?? 42.882004;
          final longitude = data?.longitude ?? 74.582748;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Выберите адрес доставки',
                style: theme.textTheme.titleSmall,
              ),
              automaticallyImplyLeading: false,
            ),
            body: AddressSelectionMapContent(
              serviceZoneBoundary: _serviceZoneBoundary,
              onMapCreated: (controller) {
                if (!_mapControllerCompleter.isCompleted) {
                  _mapControllerCompleter.complete(controller);
                  context.read<AddressSelectionCubit>().fetchCurrentLocation();
                }
              },
              onCameraPositionChanged: (pos, reason, finished) {
                if (finished) {
                  context.read<AddressSelectionCubit>().updateCoordinates(
                        pos.target.latitude,
                        pos.target.longitude,
                      );
                }
              },
              onMapTap: _onMapTap,
              onZoomIn: () => _zoomIn(latitude, longitude),
              onZoomOut: () => _zoomOut(latitude, longitude),
              onLocate: () => context.read<AddressSelectionCubit>().fetchCurrentLocation(),
            ),
            bottomSheet: AddressSelectionSheet(
              theme: theme,
              address: address,
              isLoading: isLoading,
              deliveryPrice: deliveryPrice,
              onSearchPressed: () => _onSearchPressed(context),
              onConfirm: () {
                if (address == null || data == null) return;
                context.read<AddressSelectionCubit>().confirmAddress(
                      address: address,
                      lat: data.latitude,
                      lon: data.longitude,
                    );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _withMapController(void Function(YandexMapController) action) async {
    try {
      final controller = await _mapControllerCompleter.future;
      if (mounted) action(controller);
    } catch (_) {}
  }

  Future<void> _moveToLocation(double latitude, double longitude) async {
    await _withMapController((controller) {
      _currentZoom = _defaultZoom;
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: _currentZoom,
          ),
        ),
        animation: const MapAnimation(duration: 0.7),
      );
    });
  }

  Future<void> _zoomIn(double latitude, double longitude) async {
    await _withMapController((controller) {
      _currentZoom = (_currentZoom + 1).clamp(_minZoom, _maxZoom);
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: _currentZoom,
          ),
        ),
        animation: const MapAnimation(duration: 0.35),
      );
    });
  }

  Future<void> _zoomOut(double latitude, double longitude) async {
    await _withMapController((controller) {
      _currentZoom = (_currentZoom - 1).clamp(_minZoom, _maxZoom);
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: _currentZoom,
          ),
        ),
        animation: const MapAnimation(duration: 0.35),
      );
    });
  }

  void _onMapTap(Point point) {
    // При тапе по карте сразу переносим “цель” на точку дома
    // и затем сделаем reverse-geocode после завершения движения камеры.
    unawaited(
      context.read<AddressSelectionCubit>().setLocationFromSearch(
            null,
            point.latitude,
            point.longitude,
          ),
    );
  }

  Future<void> _initPermission() async {
    try {
      final locationService = di.sl<AppLocation>();
      if (!await locationService.checkPermission()) {
        await locationService.requestPermission();
      }
    } catch (_) {}
  }

  void _onSearchPressed(BuildContext context) {
    showMapSearchBottom(
      context,
      onSearch: (addressName, latitude, longitude) {
        if (latitude != null && longitude != null) {
          // Метод асинхронный: вычислим цену доставки и координаты.
          unawaited(
            context.read<AddressSelectionCubit>().setLocationFromSearch(
                  addressName,
                  latitude,
                  longitude,
                ),
          );
        } else {
          context.read<AddressSelectionCubit>().searchByText(addressName);
        }
      },
    );
  }
}
