import 'package:bloc/bloc.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'garnish_state.dart';

/// Загружает гарниры из категории «Гарниры» для обязательного выбора
/// при добавлении блюда с requiresGarnish.
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

  /// Предвыбор гарнира по id (из уже лежащей в корзине конфигурации блюда),
  /// чтобы при повторном открытии блюда экран показывал «Уже в корзине».
  /// `null` — «Без гарнира». Ничего не делает, если выбор уже сделан.
  void preselectGarnishId(String? garnishId) {
    if (state.selectedIndex != null) return;
    if (garnishId == null) {
      emit(state.copyWith(selectedIndex: 0));
      return;
    }
    final index = state.items.indexWhere((e) => e.id == garnishId);
    if (index >= 0) emit(state.copyWith(selectedIndex: index + 1));
  }

  /// Просит UI обратить внимание на блок гарниров (скролл + подсветка).
  void requestHighlight() => emit(state.copyWith(highlightNonce: state.highlightNonce + 1));
}
