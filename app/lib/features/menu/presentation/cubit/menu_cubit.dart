import 'package:bloc/bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;

  MenuCubit(this._menuRepository) : super(MenuInitial());

  List<CategoryEntity> menu = [];

  void getProductsWithMenu({String? query}) async {
    emit(GetMenuLoading());
    try {
      final products = await _menuRepository.getProductsWithMenu(query: query);
      menu = products;
      emit(GetMenuLoaded(products));
    } catch (e) {
      emit(GetMenuFailure());
    }
  }

  void searchMenu({String? query}) async {
    emit(SearchMenuLoading());
    try {
      final foods = await _menuRepository.searchFoods(name: query);
      emit(SearchMenuLoaded(foods));
    } catch (e) {
      emit(SearchMenuFailure());
    }
  }
}
