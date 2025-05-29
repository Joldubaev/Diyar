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
      body: const CartContentsWidget(),
    );
  }
}

class CartContentsWidget extends StatelessWidget {
  const CartContentsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CartError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        } else if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return const CartEmptyWidget();
          }

          return LoadedCartView(cartState: state);
        } else {
          return const Center(
            child: Text(
              'Неизвестное состояние корзины',
            ),
          );
        }
      },
    );
  }
}
