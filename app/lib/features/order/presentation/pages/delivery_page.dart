import 'package:auto_route/auto_route.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/order/order.dart';
import 'package:diyar/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DeliveryFormPage extends StatelessWidget {
  final List<CartItemEntity> cart;
  final int totalPrice;
  final int dishCount;
  final String? address;
  final double deliveryPrice;
  final String? initialUserName;
  final String? initialUserPhone;

  const DeliveryFormPage({
    super.key,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di.sl<DeliveryFormCubit>();
        cubit.initialize(
          subtotalPrice: totalPrice,
          deliveryPrice: deliveryPrice,
        );
        return cubit;
      },
      child: DeliveryFormPageContent(
        cart: cart,
        dishCount: dishCount,
        totalPrice: totalPrice,
        deliveryPrice: deliveryPrice,
        address: address,
        initialUserName: initialUserName,
        initialUserPhone: initialUserPhone,
      ),
    );
  }
}
