part of 'menu_bloc.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

final class MenuInitial extends MenuState {}

// GetProducts States
final class GetProductsLoading extends MenuState {}

final class GetProductsLoaded extends MenuState {
  final List< CategoryFoodEntity> foods;
  const GetProductsLoaded(this.foods);

  @override
  List<Object?> get props => [foods];
}

final class GetProductsFailure extends MenuState {
  final String message;
  const GetProductsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// SearchFoods States
final class SearchFoodsLoading extends MenuState {}

final class SearchFoodsLoaded extends MenuState {
  final List<FoodEntity> foods;
  const SearchFoodsLoaded(this.foods);

  @override
  List<Object?> get props => [foods];
}

final class SearchFoodsFailure extends MenuState {
  final String message;
  const SearchFoodsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// GetPopularFoods States
final class GetPopularFoodsLoading extends MenuState {}

final class GetPopularFoodsLoaded extends MenuState {
  final List<FoodEntity> foods;
  const GetPopularFoodsLoaded(this.foods);

  @override
  List<Object?> get props => [foods];
}

final class GetPopularFoodsFailure extends MenuState {
  final String message;
  const GetPopularFoodsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// GetFoodsByCategory States
final class GetFoodsByCategoryLoading extends MenuState {}

final class GetFoodsByCategoryLoaded extends MenuState {
  final List<CategoryEntity> categories;
  const GetFoodsByCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

final class GetFoodsByCategoryFailure extends MenuState {
  final String message;
  const GetFoodsByCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
