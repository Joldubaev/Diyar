part of 'cart_bloc.dart';

// Imports moved to cart_bloc.dart

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double totalPrice; // Calculated total price
  final int totalItems; // Calculated total items count

  const CartLoaded({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [items, totalPrice, totalItems];

  // Optional: copyWith method for easier state updates
  CartLoaded copyWith({
    List<CartItemEntity>? items,
    double? totalPrice,
    int? totalItems,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

final class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

