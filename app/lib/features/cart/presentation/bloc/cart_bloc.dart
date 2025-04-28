import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/domain/repository/cart_repository.dart'; // Assuming interface is moved
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository? _cartRepository;
  StreamSubscription<List<CartItemEntity>>? _cartSubscription;

  CartBloc(CartRepository cartRepository)
      : _cartRepository = cartRepository,
        super(CartInitial()) {
    // Register event handlers
    on<LoadCart>(_onLoadCart);
    on<_CartUpdated>(_onCartUpdated);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<IncrementItemQuantity>(_onIncrementItemQuantity);
    on<DecrementItemQuantity>(_onDecrementItemQuantity);
    on<SetItemCount>(_onSetItemCount);
    on<ClearCart>(_onClearCart);
  }

  // --- Event Handlers ---

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    _cartSubscription?.cancel(); // Cancel previous subscription if any
    try {
      _cartSubscription = _cartRepository?.getAllCartItems().listen((items) {
        // When the stream emits new data, add an internal event
        add(_CartUpdated(items));
      }, onError: (error) {
        // Handle stream errors if necessary
        addError(error);
        emit(CartError("Ошибка при загрузке корзины: ${error.toString()}"));
      });
    } catch (e) {
      emit(CartError("Ошибка при подписке на корзину: ${e.toString()}"));
    }
    // Note: Initial state will be emitted by the first stream event via _CartUpdated
  }

  void _onCartUpdated(_CartUpdated event, Emitter<CartState> emit) {
    try {
      final items = event.items;
      final totalPrice = _calculateTotalPrice(items);
      final totalItems = _calculateTotalItems(items);
      emit(CartLoaded(items: items, totalPrice: totalPrice, totalItems: totalItems));
    } catch (e) {
      emit(CartError("Ошибка при обработке обновления корзины: ${e.toString()}"));
    }
  }

  Future<void> _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
    // Optionally emit loading state if it takes time
    try {
      await _cartRepository?.addToCart(event.item);
      // State will update automatically via the stream listener calling _onCartUpdated
    } catch (e) {
      emit(CartError("Ошибка добавления товара: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) async {
    try {
      await _cartRepository?.removeFromCart(event.foodId);
      // State will update automatically
    } catch (e) {
      emit(CartError("Ошибка удаления товара: ${e.toString()}"));
    }
  }

  Future<void> _onIncrementItemQuantity(IncrementItemQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartRepository?.incrementCart(event.foodId);
      // State will update automatically
    } catch (e) {
      emit(CartError("Ошибка увеличения количества: ${e.toString()}"));
    }
  }

  Future<void> _onDecrementItemQuantity(DecrementItemQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartRepository?.decrementCart(event.foodId);
      // State will update automatically
    } catch (e) {
      emit(CartError("Ошибка уменьшения количества: ${e.toString()}"));
    }
  }

  Future<void> _onSetItemCount(SetItemCount event, Emitter<CartState> emit) async {
    try {
      await _cartRepository?.setCartItemCount(event.item);
      // State will update automatically
    } catch (e) {
      emit(CartError("Ошибка установки количества: ${e.toString()}"));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading()); // Show loading while clearing
    try {
      await _cartRepository?.clearCart();
      // State will update automatically
    } catch (e) {
      emit(CartError("Ошибка очистки корзины: ${e.toString()}"));
    }
  }

  // --- Helper Methods ---

  double _calculateTotalPrice(List<CartItemEntity> items) {
    return items.fold(0.0, (sum, item) {
      final price = item.food?.price?.toDouble() ?? 0.0;
      final quantity = item.quantity ?? 0;
      return sum + (price * quantity);
    });
  }

  int _calculateTotalItems(List<CartItemEntity> items) {
    return items.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  // --- Cleanup ---

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
