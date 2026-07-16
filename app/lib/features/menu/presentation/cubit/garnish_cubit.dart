import 'package:bloc/bloc.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'garnish_state.dart';

/// Загружает гарниры из категории «Гарниры» для обязательного выбора
/// при добавлении блюда с requiresGarnish (в GarnishPickerSheet).
@injectable
class GarnishCubit extends Cubit<GarnishState> {
  final MenuRepository _menuRepository;

  GarnishCubit(this._menuRepository) : super(const GarnishState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    final result = await _menuRepository.getProducts(foodName: AppConst.garnishCategoryName);
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(isLoading: false, hasError: true)),
      (categories) {
        final items = categories.isEmpty
            ? <FoodEntity>[]
            : categories.first.foodModels.where((f) => !(f.stopList ?? false)).toList();
        emit(state.copyWith(isLoading: false, items: items, hasError: false));
      },
    );
  }

  /// Выбор пункта: `0` — «Без гарнира», `index + 1` — гарнир из списка.
  void select(int index) => emit(state.copyWith(selectedIndex: index));
}
