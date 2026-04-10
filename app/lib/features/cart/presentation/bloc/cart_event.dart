part of 'cart_bloc.dart';

// Imports moved to cart_bloc.dart

@immutable
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// Event to initially load/subscribe to cart items
class LoadCart extends CartEvent {}

// Event triggered when the cart stream updates
class _CartUpdated extends CartEvent {
  final List<CartItemEntity> items;
  const _CartUpdated(this.items);

  @override
  List<Object?> get props => [items];
}

// Event to add an item
class AddItemToCart extends CartEvent {
  final CartItemEntity item;
  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

// Event to remove an item by food ID
class RemoveItemFromCart extends CartEvent {
  final String foodId;
  const RemoveItemFromCart(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

// Event to increment item quantity by food ID
class IncrementItemQuantity extends CartEvent {
  final String foodId;
  const IncrementItemQuantity(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

// Event to decrement item quantity by food ID
class DecrementItemQuantity extends CartEvent {
  final String foodId;
  const DecrementItemQuantity(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

// Event to set a specific count for an item
class SetItemCount extends CartEvent {
  final CartItemEntity item;
  const SetItemCount(this.item);

  @override
  List<Object?> get props => [item];
}

// Event to clear the entire cart
class ClearCart extends CartEvent {}

/// События с карточки товара (меню / «Популярное»): правила add vs increment в [CartBloc].
class ProductCardIncrementRequested extends CartEvent {
  final FoodEntity food;
  final int displayedQuantity;

  const ProductCardIncrementRequested({
    required this.food,
    required this.displayedQuantity,
  });

  @override
  List<Object?> get props => [food, displayedQuantity];
}

class ProductCardDecrementRequested extends CartEvent {
  final FoodEntity food;
  final int displayedQuantity;

  const ProductCardDecrementRequested({
    required this.food,
    required this.displayedQuantity,
  });

  @override
  List<Object?> get props => [food, displayedQuantity];
}

class ProductCardCountCommitted extends CartEvent {
  final FoodEntity food;
  final int newQuantity;

  const ProductCardCountCommitted({
    required this.food,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [food, newQuantity];
}

