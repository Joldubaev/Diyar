import 'package:diyar/core/utils/api_error_utils.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'menu_products_state.dart';

@injectable
class MenuProductsCubit extends Cubit<MenuProductsState> {
  final MenuRepository _repository;
  final Map<String, List<FoodEntity>> _cache = {};

  MenuProductsCubit(this._repository)
      : super(const MenuProductsState(isInitialLoading: true));

  /// Заводит секции-плейсхолдеры для всех категорий и параллельно
  /// подгружает блюда, обновляя каждую секцию по мере готовности.
  Future<void> loadAllSections(List<CategoryEntity> categories) async {
    final names = categories.map((c) => c.name ?? '').where((n) => n.trim().isNotEmpty).toList();

    if (names.isEmpty) {
      emit(const MenuProductsState());
      return;
    }

    emit(MenuProductsState(
      sections: [for (final n in names) CategorySection(categoryName: n, isLoading: true)],
    ));

    await Future.wait(names.map(_loadSection));
  }

  Future<void> _loadSection(String name) async {
    if (_cache.containsKey(name)) {
      _updateSection(name, foods: _cache[name]!, isLoading: false);
      return;
    }

    final result = await _repository.getProducts(foodName: name);
    if (isClosed) return;
    result.fold(
      (f) {
        if (ApiErrorUtils.isNotFoundMessage(f.message)) {
          _cache[name] = const [];
          _updateSection(name, foods: const [], isLoading: false);
        } else {
          _updateSection(name, isLoading: false, error: f.message);
        }
      },
      (foods) {
        final list = foods.isNotEmpty ? foods.first.foodModels : const <FoodEntity>[];
        _cache[name] = list;
        _updateSection(name, foods: list, isLoading: false);
      },
    );
  }

  void _updateSection(String name, {List<FoodEntity>? foods, bool? isLoading, String? error}) {
    if (isClosed) return;
    final updated = state.sections.map((s) {
      if (s.categoryName != name) return s;
      return s.copyWith(foods: foods, isLoading: isLoading, error: error);
    }).toList();
    emit(state.copyWith(sections: updated));
  }

  void clearCache() => _cache.clear();
}
