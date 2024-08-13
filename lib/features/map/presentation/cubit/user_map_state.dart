part of 'user_map_cubit.dart';

sealed class UserMapState extends Equatable {
  const UserMapState();

  @override
  List<Object> get props => [];
}

final class UserMapInitial extends UserMapState {}

final class GetDelPriceLoading extends UserMapState {}

final class GetDelPriceLoaded extends UserMapState {
  final int price;

  const GetDelPriceLoaded(this.price);

  @override
  List<Object> get props => [price];
}

final class GetDelPriceError extends UserMapState {}
