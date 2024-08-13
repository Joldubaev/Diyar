import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/map/presentation/cubit/user_map_cubit.dart';
import 'package:diyar/features/map/presentation/user_map/order_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderMapPage extends StatelessWidget {
  final int totalPrice;
  final List<CartItemModel> cart;
  const OrderMapPage({super.key, required this.cart, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserMapCubit(),
      child: OrderMapWidget(
        cart: cart,
        totalPrice: totalPrice,
      ),
    );
  }
}
