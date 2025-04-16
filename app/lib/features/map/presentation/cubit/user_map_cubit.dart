import '../../data/repositories/yandex_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_map_state.dart';

class UserMapCubit extends Cubit<UserMapState> {
  UserMapCubit() : super(UserMapInitial());

  LocationService locationService = LocationService();

  int _price = 0;

  get delPrice => _price;

  void getDeliveryPrice(double latitude, double longitude) async {
    emit(GetDelPriceLoading());
    _price = await locationService.getDeliveryPrice(latitude, longitude);
    emit(GetDelPriceLoaded(_price));
  }
}
