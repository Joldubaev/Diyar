import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:dartz/dartz.dart';
import 'package:diyar/core/network/error/failures.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;
  List<CategoryEntity> categories = [];
  List<FoodEntity> popularFoods = [];

  MenuBloc(this._menuRepository) : super(MenuInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<SearchFoodsEvent>(_onSearchFoods);
    on<GetPopularFoodsEvent>(_onGetPopularFoods);
    on<GetFoodsByCategoryEvent>(_onGetFoodsByCategory);
  }

  Future<void> _onGetProducts(GetProductsEvent event, Emitter<MenuState> emit) async {
    emit(GetProductsLoading());
    try {
      final Either<Failure, List<FoodEntity>> result = await _menuRepository.getProducts(foodName: event.foodName);
      result.fold(
        (failure) => emit(GetProductsFailure(failure.toString())),
        (foods) => emit(GetProductsLoaded(foods)),
      );
    } catch (e) {
      emit(GetProductsFailure(e.toString()));
    }
  }

  Future<void> _onSearchFoods(SearchFoodsEvent event, Emitter<MenuState> emit) async {
    emit(SearchFoodsLoading());
    try {
      final Either<Failure, List<FoodEntity>> result = await _menuRepository.searchFoods(query: event.query);
      result.fold(
        (failure) => emit(SearchFoodsFailure(failure.toString())),
        (foods) => emit(SearchFoodsLoaded(foods)),
      );
    } catch (e) {
      emit(SearchFoodsFailure(e.toString()));
    }
  }

  Future<void> _onGetPopularFoods(GetPopularFoodsEvent event, Emitter<MenuState> emit) async {
    emit(GetPopularFoodsLoading());
    try {
      final Either<Failure, List<FoodEntity>> result = await _menuRepository.getPopularFoods();
      result.fold(
        (failure) => emit(GetPopularFoodsFailure(failure.toString())),
        (foods) {
          popularFoods = foods;
          emit(GetPopularFoodsLoaded(foods));
        },
      );
    } catch (e) {
      emit(GetPopularFoodsFailure(e.toString()));
    }
  }

  Future<void> _onGetFoodsByCategory(GetFoodsByCategoryEvent event, Emitter<MenuState> emit) async {
    emit(GetFoodsByCategoryLoading());
    try {
      final Either<Failure, List<CategoryEntity>> result = await _menuRepository.getFoodsByCategory();
      result.fold(
        (failure) => emit(GetFoodsByCategoryFailure(failure.toString())),
        (categories) {
          this.categories = categories;
          emit(GetFoodsByCategoryLoaded(categories));
        },
      );
    } catch (e) {
      emit(GetFoodsByCategoryFailure(e.toString()));
    }
  }
}
