import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'search_state.dart';

@injectable
class MenuSearchCubit extends Cubit<MenuSearchState> {
  final MenuRepository _repository;

  MenuSearchCubit(this._repository) : super(const MenuSearchState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const MenuSearchState());
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.searchFoods(query: query);
    if (isClosed) return;
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (foods) => emit(state.copyWith(isLoading: false, results: foods)),
    );
  }

  void clear() => emit(const MenuSearchState());
}
