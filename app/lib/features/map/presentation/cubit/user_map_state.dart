part of 'user_map_cubit.dart';

sealed class UserMapState extends Equatable {
  const UserMapState();

  @override
  List<Object> get props => [];
}

final class UserMapInitial extends UserMapState {}

final class GetDistrictPriceLoading extends UserMapState {}

final class GetDistrictPriceLoaded extends UserMapState {
  final PriceModel priceModel;

  const GetDistrictPriceLoaded(this.priceModel);

  @override
  List<Object> get props => [priceModel];
}

final class GetDelPriceError extends UserMapState {
  final String? message;

  const GetDelPriceError([this.message]);

  @override
  List<Object> get props => [message ?? ''];
}
