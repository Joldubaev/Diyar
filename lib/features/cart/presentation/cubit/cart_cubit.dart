import 'package:bloc/bloc.dart';
import 'package:diyar/core/utils/helper/user_helper.dart';
import 'package:diyar/features/cart/data/data.dart';
import 'package:diyar/features/cart/data/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  CartCubit(this._cartRepository) : super(CartInitial());

  Stream<List<CartItemModel>> cart = const Stream.empty();

  int dishCount = 0;
  int totalPrice = 0;

  Future<void> getCartItems() async {
    emit(GetAllCartLoading());
    try {
      cart = !UserHelper.isAuth()
          ? const Stream.empty()
          : _cartRepository.getAllCartItems();
      emit(GetAllCartLoaded(items: cart));
    } catch (e) {
      emit(GetAllCartError());
    }
  }

  Future<void> addToCart(CartItemModel product) async {
    try {
      await _cartRepository.addToCart(product);
      emit(AddToCartSuccess());
      getCartItems(); 
    } catch (e) {
      emit(AddToCartError());
    }
  }

  Future<void> removeFromCart(String id) async {
    try {
      await _cartRepository.removeFromCart(id);
      emit(RemoveFromCartSuccess());
      getCartItems();
    } catch (e) {
      emit(RemoveFromCartError());
    }
  }

  Future<void> incrementCart(String id) async {
    await _cartRepository.incrementCart(id);
    getCartItems(); // Refresh cart items
  }

  Future<void> decrementCart(String id) async {
    await _cartRepository.decrementCart(id);
    getCartItems(); // Refresh cart items
  }

  void incrementDishCount() {
    dishCount++;
    emit(DishCountUpdated(dishCount: dishCount));
  }

  void decrementDishCount() {
    dishCount--;
    emit(DishCountUpdated(dishCount: dishCount));
  }

  void changeTotalPrice(int price) {
    totalPrice = price;
    emit(TotalPriceUpdated(totalPrice: totalPrice));
  }

  Future<void> clearCart() async {
    emit(ClearCartLoading());
    try {
      await _cartRepository.clearCart();
      emit(ClearCartLoaded());
      getCartItems(); // Refresh cart items
    } catch (e) {
      emit(ClearCartError());
    }
  }

  Future<void> setCartItemCount(CartItemModel cart) async {
    emit(SetCartItemLoading());
    try {
      await _cartRepository.setCartItemCount(cart);
      emit(SetCartItemLoaded());
      getCartItems(); // Refresh cart items
    } catch (e) {
      emit(SetCartItemError());
    }
  }
}
