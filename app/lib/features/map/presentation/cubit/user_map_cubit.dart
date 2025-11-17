import 'dart:developer';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/map/presentation/widgets/coordinats_backup.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/data/models/price_model.dart';
import 'package:diyar/features/map/data/repositories/price_repository.dart';
import 'package:diyar/core/utils/helper/map_helper.dart';
import 'package:injectable/injectable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_map_state.dart';

@injectable
class UserMapCubit extends Cubit<UserMapState> {
  final PriceRepository priceRepository;
  final AppLocation locationService;
  
  UserMapCubit(this.priceRepository, this.locationService) : super(UserMapInitial());

  void getDeliveryPrice(double latitude, double longitude) async {
    try {
      emit(GetDistrictPriceLoading());

      // Определяем yandexId по координатам
      final yandexId = MapHelper.getYandexIdForCoordinate(
        latitude,
        longitude,
        polygons: Polygons.getPolygons(),
      );

      log('YandexId found: $yandexId for coordinates: $latitude, $longitude');

      if (yandexId != null) {
        // Отправляем yandexId в API
        final priceModel = await priceRepository.getDistrictPrice(yandexId: yandexId.toString());
        log('Price from API: ${priceModel.price}');
        emit(GetDistrictPriceLoaded(priceModel));
      } else {
        // Если точка не в полигоне, используем fallback цену
        final fallbackPrice = MapHelper.isCoordinateInsidePolygons(
          latitude,
          longitude,
          polygons: Polygons.getPolygons(),
        );
        log('Fallback price: $fallbackPrice');
        emit(GetDistrictPriceLoaded(
          PriceModel(
            districtId: null,
            districtName: null,
            price: fallbackPrice.toInt(),
            yandexId: null,
          ),
        ));
      }
    } catch (e) {
      log('Error in getDeliveryPrice: $e');
      emit(GetDelPriceError(e.toString()));
    }
  }
}
