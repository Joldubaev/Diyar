import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'menu_category_state.dart';

@injectable
class MenuCategoryCubit extends Cubit<MenuCategoryState> {
  final MenuRepository _repository;

  MenuCategoryCubit(this._repository) : super(const MenuCategoryState());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.getFoodsCategory();
    if (isClosed) return;
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (categories) {
        emit(state.copyWith(isLoading: false, categories: categories));
      },
    );
  }

  void selectCategory(int index) {
    if (index >= 0 && index < state.categories.length) {
      emit(state.copyWith(activeIndex: index));
    }
  }

  String? get activeCategoryName {
    if (state.categories.isEmpty) return null;
    if (state.activeIndex >= state.categories.length) return null;
    return state.categories[state.activeIndex].name;
  }
}
