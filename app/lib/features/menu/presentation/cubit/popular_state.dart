part of 'popular_cubit.dart';

abstract class PopularState extends Equatable {
  const PopularState();

  @override
  List<Object> get props => [];
}

class PopularInitial extends PopularState {}

class PopularLoading extends PopularState {}

class PopularLoaded extends PopularState {
  final List<FoodEntity> products;

  const PopularLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class PopularError extends PopularState {
  final String message;

  const PopularError(this.message);

  @override
  List<Object> get props => [message];
}
