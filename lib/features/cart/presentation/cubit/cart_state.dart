part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class GetAllCartLoading extends CartState {}

class GetAllCartLoaded extends CartState {
  final Stream<List<CartItemModel>> items;

  const GetAllCartLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class GetAllCartError extends CartState {}

class AddToCartSuccess extends CartState {}

class AddToCartError extends CartState {}

class RemoveFromCartSuccess extends CartState {}

class RemoveFromCartError extends CartState {}

class ChangeStateLoading extends CartState {}

class ChangeStateLoaded extends CartState {}

class ClearCartLoading extends CartState {}

class ClearCartLoaded extends CartState {}

class ClearCartError extends CartState {}

class SetCartItemLoading extends CartState {}

class SetCartItemLoaded extends CartState {}

class SetCartItemError extends CartState {}