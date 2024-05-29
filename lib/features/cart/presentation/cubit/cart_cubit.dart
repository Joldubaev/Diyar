import 'package:bloc/bloc.dart';
import 'package:diyar/features/cart/data/models/models.dart';
import 'package:diyar/features/cart/data/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartReposiory;
  CartCubit(this._cartReposiory) : super(CartInitial());

  Stream<List<CartItemModel>> cart = const Stream.empty();

  int dishCount = 0;
  int totalPrice = 0;

  Future getCartItems() async {
    emit(GetAllCartLoading());
    try {
      cart = _cartReposiory.getAllCartItems();
      emit(GetAllCartLoaded(items: cart));
    } catch (e) {
      emit(GetAllCartError());
    }
  }

  addToCart(CartItemModel product) async {
    try {
      await _cartReposiory.addToCart(product);
      emit(AddToCartSuccess());
    } catch (e) {
      emit(AddToCartError());
    }
  }

  removeFromCart(String id) async {
    try {
      await _cartReposiory.removeFromCart(id);
      emit(RemoveFromCartSuccess());
    } catch (e) {
      emit(RemoveFromCartError());
    }
  }

  incrementCart(String id) async {
    await _cartReposiory.incrementCart(id);
  }

  decrementCart(String id) async {
    await _cartReposiory.decrementCart(id);
  }

  incrementDishCount() {
    emit(ChangeStateLoading());
    dishCount++;
    emit(ChangeStateLoaded());
  }

  decrementDishCount() {
    emit(ChangeStateLoading());
    dishCount--;
    emit(ChangeStateLoaded());
  }

  changeTotalPrice(int price) {
    emit(ChangeStateLoading());
    totalPrice = price;
    emit(ChangeStateLoaded());
  }

  clearCart() async {
    emit(ClearCartLoading());
    try {
      await _cartReposiory.clearCart();
      emit(ClearCartLoaded());
    } catch (e) {
      emit(ClearCartError());
    }
  }
}
