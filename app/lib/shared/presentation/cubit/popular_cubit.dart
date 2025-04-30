import 'package:diyar/features/menu/domain/domain.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_state.dart';

class PopularCubit extends Cubit<PopularState> {
  PopularCubit(this._menuRepository) : super(PopularInitial());

  final MenuRepository _menuRepository;

  List<FoodEntity> popularFoods = [];

  Future<void> getPopularProducts() async {
    emit(PopularLoading());
    final result = await _menuRepository.getPopularFoods();
    result.fold(
      (failure) => emit(PopularError(failure.message)),
      (foods) => emit(PopularLoaded(foods)),
    );
  }
}
