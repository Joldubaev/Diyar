import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCounterWidget extends StatelessWidget {
  final bool? isShadowVisible;
  final int? count;
  final String id;
  final VoidCallback? onAddToCart;

  const ProductCounterWidget({
    super.key,
    this.isShadowVisible = true,
    this.count,
    required this.id,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: isShadowVisible! ? MainAxisSize.max : MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (count! > 1) {
                context.read<CartCubit>().decrementCart(id);
              }
            },
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Icon(Icons.remove),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Text('$count', style: theme.textTheme.bodyMedium),
          ),
          IconButton(
            onPressed: () {
              context.read<CartCubit>().incrementCart(id);
            },
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
