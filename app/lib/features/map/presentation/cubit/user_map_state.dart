part of 'user_map_cubit.dart';

sealed class UserMapState extends Equatable {
  const UserMapState();

  @override
  List<Object?> get props => [];
}

final class UserMapInitial extends UserMapState {
  const UserMapInitial();
}

final class GetDistrictPriceLoading extends UserMapState {
  const GetDistrictPriceLoading();
}

final class GetDistrictPriceLoaded extends UserMapState {
  final DeliveryPriceEntity priceEntity;

  const GetDistrictPriceLoaded(this.priceEntity);

  @override
  List<Object?> get props => [priceEntity];
}

final class GetDelPriceError extends UserMapState {
  final String message;

  const GetDelPriceError(this.message);

  @override
  List<Object?> get props => [message];
}
