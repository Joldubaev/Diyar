import 'package:diyar/core/utils/api_error_utils.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'menu_products_state.dart';

@injectable
class MenuProductsCubit extends Cubit<MenuProductsState> {
  final MenuRepository _repository;
  final Map<String, List<CategoryFoodEntity>> _cache = {};

  MenuProductsCubit(this._repository)
      : super(const MenuProductsState(isLoading: true));

  Future<void> loadProducts(String categoryName) async {
    if (_cache.containsKey(categoryName)) {
      emit(state.copyWith(isLoading: false, foods: _cache[categoryName]!, error: null));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.getProducts(foodName: categoryName);
    if (isClosed) return;
    result.fold(
      (f) {
        if (ApiErrorUtils.isNotFoundMessage(f.message)) {
          _cache[categoryName] = [];
          emit(state.copyWith(isLoading: false, foods: const [], error: null));
        } else {
          emit(state.copyWith(isLoading: false, error: f.message));
        }
      },
      (foods) {
        _cache[categoryName] = foods;
        emit(state.copyWith(isLoading: false, foods: foods, error: null));
      },
    );
  }

  void clearCache() => _cache.clear();
}
