import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  double _currentZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _initPermission();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => di.sl<AddressSelectionCubit>(),
      child: BlocConsumer<AddressSelectionCubit, AddressSelectionState>(
        listenWhen: (prev, curr) =>
            curr is AddressSelectionConfirmed || curr is AddressSelectionMoveTo || curr is AddressSelectionSearchError,
        listener: (context, state) {
          if (state is AddressSelectionConfirmed) {
            context.router.replace(const MainHomeRoute());
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
              onZoomIn: () => _zoomIn(latitude, longitude),
              onZoomOut: () => _zoomOut(latitude, longitude),
              onLocate: () => context.read<AddressSelectionCubit>().fetchCurrentLocation(),
            ),
            bottomSheet: AddressSelectionSheet(
              theme: theme,
              address: address,
              isLoading: isLoading,
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
      _currentZoom = 16.0;
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: 16.0,
          ),
        ),
      );
    });
  }

  Future<void> _zoomIn(double latitude, double longitude) async {
    await _withMapController((controller) {
      _currentZoom += 1;
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: _currentZoom,
          ),
        ),
      );
    });
  }

  Future<void> _zoomOut(double latitude, double longitude) async {
    await _withMapController((controller) {
      _currentZoom -= 1;
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: latitude, longitude: longitude),
            zoom: _currentZoom,
          ),
        ),
      );
    });
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
          context.read<AddressSelectionCubit>().setLocationFromSearch(
                addressName,
                latitude,
                longitude,
              );
        } else {
          context.read<AddressSelectionCubit>().searchByText(addressName);
        }
      },
    );
  }
}
