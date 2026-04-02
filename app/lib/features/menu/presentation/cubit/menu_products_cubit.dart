import 'package:diyar/features/menu/domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'menu_products_state.dart';

@injectable
class MenuProductsCubit extends Cubit<MenuProductsState> {
  final MenuRepository _repository;

  MenuProductsCubit(this._repository) : super(const MenuProductsState());

  Future<void> loadProducts(String categoryName) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await _repository.getProducts(foodName: categoryName);
    if (isClosed) return;
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (foods) => emit(state.copyWith(isLoading: false, foods: foods)),
    );
  }
}
