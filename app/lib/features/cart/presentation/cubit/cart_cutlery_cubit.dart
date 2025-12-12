import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'cart_cutlery_state.dart';

/// Cubit для управления количеством столовых приборов
@injectable
class CartCutleryCubit extends Cubit<CartCutleryState> {
  CartCutleryCubit() : super(const CartCutleryInitial());

  void setCutleryCount(int count) {
    if (count < 0) return;
    emit(CartCutlerySet(count: count));
  }

  void increment() {
    final currentCount = _getCurrentCount();
    setCutleryCount(currentCount + 1);
  }

  void decrement() {
    final currentCount = _getCurrentCount();
    if (currentCount > 0) {
      setCutleryCount(currentCount - 1);
    }
  }

  int _getCurrentCount() {
    final state = this.state;
    if (state is CartCutlerySet) {
      return state.count;
    }
    return 0;
  }
}
