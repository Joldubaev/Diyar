import 'package:diyar/features/menu/domain/domain.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_state.dart';

class PopularCubit extends Cubit<PopularState> {
  PopularCubit(this._menuRepository) : super(PopularInitial());

  final MenuRepository _menuRepository;

  List<FoodEntity> popularFoods = [];

  Future getPopularProducts() async {
    emit(PopularLoading());
    try {
      final product = await _menuRepository.getPopularFoods();
      // popularFoods = product;
      // emit(PopularLoaded(product));
    } catch (e) {
      emit(const PopularError('Ошибка загрузки данных'));
    }
  }
}
