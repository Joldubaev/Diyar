import 'dart:developer';

import 'package:diyar/core/bloc/base_cubit.dart';
import 'package:diyar/core/utils/helper/map_helper.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'user_map_state.dart';

@injectable
class UserMapCubit extends BaseCubit<UserMapState> {
  final PriceRepository _priceRepository;
  final AppLocation locationService;

  UserMapCubit(this._priceRepository, this.locationService)
      : super(const UserMapInitial());

  Future<void> getDeliveryPrice(double latitude, double longitude) async {
    safeEmit(const GetDistrictPriceLoading());

    try {
      final yandexId = await MapHelper.getYandexIdForCoordinate(latitude, longitude);
      log('YandexId found: $yandexId for coordinates: $latitude, $longitude');

      if (yandexId != null) {
        final result = await _priceRepository.getDistrictPrice(yandexId: yandexId.toString());
        if (isClosed) return;
        result.fold(
          (f) => safeEmit(GetDelPriceError(f.message)),
          (entity) {
            log('Price from API: ${entity.price}');
            safeEmit(GetDistrictPriceLoaded(entity));
          },
        );
      } else {
        log('Fallback price: 600');
        safeEmit(const GetDistrictPriceLoaded(
          DeliveryPriceEntity(price: 600),
        ));
      }
    } catch (e) {
      log('Error in getDeliveryPrice: $e');
      safeEmit(GetDelPriceError(e.toString()));
    }
  }
}
