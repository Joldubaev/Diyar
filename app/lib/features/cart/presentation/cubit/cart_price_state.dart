part of 'cart_price_cubit.dart';

@immutable
sealed class CartPriceState extends Equatable {
  const CartPriceState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
final class CartPriceInitial extends CartPriceState {
  const CartPriceInitial();
}

/// Рассчитанные цены
final class CartPriceCalculated extends CartPriceState {
  final double itemsPrice;
  final double containerPrice;
  final double monetaryDiscount;
  final double subtotalPrice;

  const CartPriceCalculated({
    required this.itemsPrice,
    required this.containerPrice,
    required this.monetaryDiscount,
    required this.subtotalPrice,
  });

  @override
  List<Object?> get props => [
        itemsPrice,
        containerPrice,
        monetaryDiscount,
        subtotalPrice,
      ];
}
