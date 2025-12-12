import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartAppBarWidget(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is CartLoaded) {
            return CartView(initialItems: state.items);
          }
          return const Center(
            child: Text('Неизвестное состояние корзины'),
          );
        },
      ),
    );
  }
}
