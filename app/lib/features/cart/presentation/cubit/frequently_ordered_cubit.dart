import 'package:bloc/bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'frequently_ordered_state.dart';

/// Загружает блок «Так же заказывают» под корзиной.
/// Пустой список (в т.ч. при 404) → блок скрывается.
@injectable
class FrequentlyOrderedCubit extends Cubit<FrequentlyOrderedState> {
  final MenuRepository _menuRepository;

  FrequentlyOrderedCubit(this._menuRepository) : super(const FrequentlyOrderedState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    final result = await _menuRepository.getFrequentlyOrderedFoods();
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(isLoading: false, hasError: true)),
      (items) => emit(state.copyWith(isLoading: false, items: items, hasError: false)),
    );
  }
}
