import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'dart:developer';

part 'menu_event.dart';
part 'menu_state.dart';

@injectable
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _menuRepository;

  MenuBloc(
    this._menuRepository,
  ) : super(MenuInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<SearchFoodsEvent>(_onSearchFoods);
    on<GetPopularFoodsEvent>(_onGetPopularFoods);
    on<GetFoodsByCategoryEvent>(_onGetFoodsCategory);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onGetProducts(GetProductsEvent event, Emitter<MenuState> emit) async {
    emit(GetProductsLoading());
    try {
      final result = await _menuRepository.getProducts(foodName: event.foodName);
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
      final result = await _menuRepository.searchFoods(query: event.query);
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
      final result = await _menuRepository.getPopularFoods();
      result.fold(
        (failure) => emit(GetPopularFoodsFailure(failure.toString())),
        (foods) => emit(GetPopularFoodsLoaded(foods)),
      );
    } catch (e) {
      emit(GetPopularFoodsFailure(e.toString()));
    }
  }

  Future<void> _onGetFoodsCategory(GetFoodsByCategoryEvent event, Emitter<MenuState> emit) async {
    emit(GetFoodsByCategoryLoading());
    try {
      final result = await _menuRepository.getFoodsCategory();
      result.fold(
        (failure) => emit(GetFoodsByCategoryFailure(failure.toString())),
        (categories) {
          emit(GetFoodsByCategoryLoaded(categories));
        },
      );
    } catch (e) {
      emit(GetFoodsByCategoryFailure(e.toString()));
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<MenuState> emit,
  ) async {
    log("Clearing search state");
    emit(MenuInitial());
  }
}
