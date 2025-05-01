part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends MenuEvent {
  final String? foodName;

  const GetProductsEvent({required this.foodName});

  @override
  List<Object> get props => [foodName ?? ''];
}

class SearchFoodsEvent extends MenuEvent {
  final String query;

  const SearchFoodsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetPopularFoodsEvent extends MenuEvent {}

class GetFoodsByCategoryEvent extends MenuEvent {}

class ClearSearchEvent extends MenuEvent {}
