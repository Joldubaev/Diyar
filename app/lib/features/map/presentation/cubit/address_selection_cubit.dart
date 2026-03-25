import 'package:bloc/bloc.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/utils/helper/map_helper.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/map/data/repositories/price_repository.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/presentation/widgets/coordinats_backup.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'address_selection_state.dart';

/// BoundingBox зоны обслуживания для ограничения поиска Yandex (охватывает полигон).
const _serviceZoneBounds = BoundingBox(
  northEast: Point(latitude: 42.957, longitude: 74.924),
  southWest: Point(latitude: 42.71, longitude: 74.285),
);

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
      deliveryPrice: state is AddressSelectionData ? (state as AddressSelectionData).deliveryPrice : 0,
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

      if (result.items != null && result.items!.isNotEmpty) {
        emit(AddressSelectionData(
          latitude: lat,
          longitude: lon,
          address: result.items!.first.name,
          deliveryPrice: deliveryPrice,
          isLoading: false,
        ));
      } else {
        emit(AddressSelectionData(
          latitude: lat,
          longitude: lon,
          address: 'Адрес не найден',
          deliveryPrice: deliveryPrice,
          isLoading: false,
        ));
      }
    } catch (_) {
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
    } catch (_) {
      final data = state is AddressSelectionData ? state as AddressSelectionData : null;
      if (data != null && !isClosed) {
        emit(AddressSelectionMoveTo(data.latitude, data.longitude));
      }
    }
  }

  Future<void> setLocationFromSearch(String? address, double lat, double lon) async {
    if (!MapHelper.isPointInServiceZone(lat, lon)) {
      emit(AddressSelectionSearchError('Адрес находится за пределами зоны доставки'));
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
    if (!lowerQuery.contains('чуйск') && !lowerQuery.contains('бишкек') && !lowerQuery.contains('bishkek')) {
      searchQuery = '$searchQuery Чуйская область';
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

      final firstItem = result.items!.first;
      if (firstItem.geometry.isEmpty) {
        emit(AddressSelectionSearchError('Адрес не найден'));
        return;
      }

      final point = firstItem.geometry.first.point;
      if (point == null) {
        emit(AddressSelectionSearchError('Адрес не найден'));
        return;
      }

      if (!MapHelper.isPointInServiceZone(point.latitude, point.longitude)) {
        emit(AddressSelectionSearchError('Адрес находится за пределами зоны доставки'));
        return;
      }

      emit(AddressSelectionMoveTo(point.latitude, point.longitude));
      if (isClosed) return;

      final deliveryPrice = await _calculateDeliveryPrice(point.latitude, point.longitude);
      emit(AddressSelectionData(
        latitude: point.latitude,
        longitude: point.longitude,
        address: firstItem.name,
        deliveryPrice: deliveryPrice,
        isLoading: false,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(AddressSelectionSearchError('Ошибка поиска'));
    }
  }

  Future<void> confirmAddress({
    required String address,
    required double lat,
    required double lon,
  }) async {
    if (!MapHelper.isPointInServiceZone(lat, lon)) {
      emit(AddressSelectionSearchError('Адрес находится за пределами зоны доставки'));
      return;
    }

    emit(const AddressSelectionLoading());

    double deliveryPrice = 0;
    try {
      final yandexId = MapHelper.getYandexIdForCoordinate(
        lat,
        lon,
        polygons: Polygons.getPolygons(),
      );
      if (yandexId != null) {
        final priceModel = await _priceRepository.getDistrictPrice(
          yandexId: yandexId.toString(),
        );
        deliveryPrice = priceModel.price?.toDouble() ?? 0;
      } else {
        deliveryPrice = MapHelper.isCoordinateInsidePolygons(
          lat,
          lon,
          polygons: Polygons.getPolygons(),
        );
      }
    } catch (_) {
      deliveryPrice = MapHelper.isCoordinateInsidePolygons(
        lat,
        lon,
        polygons: Polygons.getPolygons(),
      );
    }

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
      final yandexId = MapHelper.getYandexIdForCoordinate(
        lat,
        lon,
        polygons: Polygons.getPolygons(),
      );

      if (yandexId != null) {
        final priceModel = await _priceRepository.getDistrictPrice(
          yandexId: yandexId.toString(),
        );
        return priceModel.price?.toDouble() ?? 0;
      }

      return MapHelper.isCoordinateInsidePolygons(
        lat,
        lon,
        polygons: Polygons.getPolygons(),
      );
    } catch (_) {
      return MapHelper.isCoordinateInsidePolygons(
        lat,
        lon,
        polygons: Polygons.getPolygons(),
      );
    }
  }
}
