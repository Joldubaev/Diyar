part of 'cart_cutlery_cubit.dart';

sealed class CartCutleryState extends Equatable {
  const CartCutleryState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
final class CartCutleryInitial extends CartCutleryState {
  const CartCutleryInitial();
}

/// Установленное количество столовых приборов
final class CartCutlerySet extends CartCutleryState {
  final int count;

  const CartCutlerySet({required this.count});

  @override
  List<Object?> get props => [count];
}
