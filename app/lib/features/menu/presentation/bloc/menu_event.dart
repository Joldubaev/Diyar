part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends MenuEvent {
  final String? foodName;
  const GetProductsEvent({this.foodName});
}

class SearchFoodsEvent extends MenuEvent {
  final String? query;
  const SearchFoodsEvent({this.query});
}

class GetPopularFoodsEvent extends MenuEvent {}

class GetFoodsByCategoryEvent extends MenuEvent {}
