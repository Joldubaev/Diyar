import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/utils/helper/map_helper.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/map/domain/domain.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'address_selection_state.dart';

/// BoundingBox зоны обслуживания для ограничения поиска Yandex.
const _serviceZoneBounds = BoundingBox(
  northEast: Point(latitude: 42.957, longitude: 74.924),
  southWest: Point(latitude: 42.71, longitude: 74.285),
);

const _fallbackDeliveryPrice = 600.0;

@injectable
class AddressSelectionCubit extends Cubit<AddressSelectionState> {
  final PriceRepository _priceRepository;
  final AddressStorageService _addressStorage;
  final AppLocation _appLocation;

  AddressSelectionCubit(
    this._priceRepository,
    this._addressStorage,
    this._appLocation,
  ) : super(const AddressSelectionData(
          latitude: 42.882004,
          longitude: 74.582748,
        ));

  void updateCoordinates(double lat, double lon) async {
    emit(AddressSelectionData(
      latitude: lat,
      longitude: lon,
      address: null,
      deliveryPrice: state is AddressSelectionData
          ? (state as AddressSelectionData).deliveryPrice
          : 0,
      isLoading: true,
    ));

    try {
      final priceFuture = _calculateDeliveryPrice(lat, lon);
      final searchSessionData = await YandexSearch.searchByPoint(
        point: Point(latitude: lat, longitude: lon),
        searchOptions: const SearchOptions(),
      );
      final result = await searchSessionData.$2;
      final deliveryPrice = await priceFuture;

      if (isClosed) return;

      final address = (result.items != null && result.items!.isNotEmpty)
          ? result.items!.first.name
          : 'Адрес не найден';

      emit(AddressSelectionData(
        latitude: lat,
        longitude: lon,
        address: address,
        deliveryPrice: deliveryPrice,
        isLoading: false,
      ));
    } catch (e) { log('[address_selection_cubit] $e');
      if (isClosed) return;
      final deliveryPrice = await _calculateDeliveryPrice(lat, lon);
      emit(AddressSelectionData(
        latitude: lat,
        longitude: lon,
        address: 'Адрес не найден',
        deliveryPrice: deliveryPrice,
        isLoading: false,
      ));
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final position = await _appLocation.getCurrentLocation();
      if (isClosed) return;
      emit(AddressSelectionMoveTo(position.latitude, position.longitude));
      if (isClosed) return;
      updateCoordinates(position.latitude, position.longitude);
    } catch (e) { log('[address_selection_cubit] $e');
      final data = state is AddressSelectionData
          ? state as AddressSelectionData
          : null;
      if (data != null && !isClosed) {
        emit(AddressSelectionMoveTo(data.latitude, data.longitude));
      }
    }
  }

  Future<void> setLocationFromSearch(
    String? address,
    double lat,
    double lon,
  ) async {
    final inZone = await MapHelper.isPointInServiceZone(lat, lon);
    if (!inZone) {
      emit(AddressSelectionSearchError(
        'Адрес находится за пределами зоны доставки',
      ));
      return;
    }
    emit(AddressSelectionMoveTo(lat, lon));
    final deliveryPrice = await _calculateDeliveryPrice(lat, lon);
    if (isClosed) return;
    emit(AddressSelectionData(
      latitude: lat,
      longitude: lon,
      address: address,
      deliveryPrice: deliveryPrice,
      isLoading: false,
    ));
  }

  Future<void> searchByText(String searchText) async {
    String searchQuery = searchText.trim();
    final lowerQuery = searchQuery.toLowerCase();
    if (!lowerQuery.contains('чуйск') &&
        !lowerQuery.contains('бишкек') &&
        !lowerQuery.contains('bishkek')) {
      searchQuery = '$searchQuery Бишкек';
    }

    try {
      final searchResult = await YandexSearch.searchByText(
        searchText: searchQuery,
        searchOptions: const SearchOptions(),
        geometry: Geometry.fromBoundingBox(_serviceZoneBounds),
      );
      final result = await searchResult.$2;
      if (isClosed) return;

      if (result.items == null || result.items!.isEmpty) {
        emit(AddressSelectionSearchError('Адрес не найден'));
        return;
      }

      Point? selectedPoint;
      String? selectedName;
      for (final item in result.items!) {
        if (item.geometry.isEmpty) continue;
        final p = item.geometry.first.point;
        if (p == null) continue;
        final inZone =
            await MapHelper.isPointInServiceZone(p.latitude, p.longitude);
        if (inZone) {
          selectedPoint = p;
          selectedName = item.name;
          break;
        }
      }

      if (selectedPoint == null) {
        emit(AddressSelectionSearchError(
          'Адрес находится за пределами зоны доставки',
        ));
        return;
      }

      emit(AddressSelectionMoveTo(
        selectedPoint.latitude,
        selectedPoint.longitude,
      ));
      if (isClosed) return;

      final deliveryPrice = await _calculateDeliveryPrice(
        selectedPoint.latitude,
        selectedPoint.longitude,
      );
      emit(AddressSelectionData(
        latitude: selectedPoint.latitude,
        longitude: selectedPoint.longitude,
        address: selectedName,
        deliveryPrice: deliveryPrice,
        isLoading: false,
      ));
    } catch (e) { log('[address_selection_cubit] $e');
      if (isClosed) return;
      emit(AddressSelectionSearchError('Ошибка поиска'));
    }
  }

  Future<void> confirmAddress({
    required String address,
    required double lat,
    required double lon,
  }) async {
    final inZone = await MapHelper.isPointInServiceZone(lat, lon);
    if (!inZone) {
      emit(AddressSelectionSearchError(
        'Адрес находится за пределами зоны доставки',
      ));
      return;
    }

    emit(const AddressSelectionLoading());

    final deliveryPrice = await _calculateDeliveryPrice(lat, lon);

    await _addressStorage.saveAddress(
      address,
      lat,
      lon,
      deliveryPrice: deliveryPrice,
    );

    if (!isClosed) {
      emit(const AddressSelectionConfirmed());
    }
  }

  Future<double> _calculateDeliveryPrice(double lat, double lon) async {
    try {
      final yandexId =
          await MapHelper.getYandexIdForCoordinate(lat, lon);

      if (yandexId != null) {
        final result = await _priceRepository.getDistrictPrice(
          yandexId: yandexId.toString(),
        );
        return result.fold(
          (_) => _fallbackDeliveryPrice,
          (entity) => entity.price.toDouble(),
        );
      }

      return _fallbackDeliveryPrice;
    } catch (e) { log('[address_selection_cubit] $e');
      return _fallbackDeliveryPrice;
    }
  }
}
