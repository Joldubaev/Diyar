import 'dart:developer';

import 'package:diyar/core/core.dart';
import 'package:diyar/core/utils/helper/map_helper.dart';
import 'package:diyar/features/map/data/models/price_model.dart';
import 'package:diyar/features/map/data/repositories/price_repository.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'user_map_state.dart';

@injectable
class UserMapCubit extends Cubit<UserMapState> {
  final PriceRepository priceRepository;
  final AppLocation locationService;

  UserMapCubit(this.priceRepository, this.locationService)
      : super(UserMapInitial());

  void getDeliveryPrice(double latitude, double longitude) async {
    try {
      emit(GetDistrictPriceLoading());

      final yandexId = await MapHelper.getYandexIdForCoordinate(
        latitude,
        longitude,
      );

      log('YandexId found: $yandexId for coordinates: $latitude, $longitude');

      if (yandexId != null) {
        final priceModel = await priceRepository.getDistrictPrice(
          yandexId: yandexId.toString(),
        );
        log('Price from API: ${priceModel.price}');
        emit(GetDistrictPriceLoaded(priceModel));
      } else {
        log('Fallback price: 600');
        emit(GetDistrictPriceLoaded(
          PriceModel(
            districtId: null,
            districtName: null,
            price: 600,
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
