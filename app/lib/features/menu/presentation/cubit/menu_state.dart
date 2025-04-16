part of 'menu_cubit.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class GetMenuLoading extends MenuState {}

class GetMenuLoaded extends MenuState {
  final List<CategoryModel> categories;

  const GetMenuLoaded(this.categories);
}

class GetMenuFailure extends MenuState {}

class SearchMenuLoading extends MenuState {}

class SearchMenuLoaded extends MenuState {
  final List<FoodModel> foods;

  const SearchMenuLoaded(this.foods);
}

class SearchMenuFailure extends MenuState {}
