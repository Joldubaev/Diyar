import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemContentWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isCounter;
  final bool? isShadowVisible;
  final int quantity;
  final FoodModel food;

  const ProductItemContentWidget({
    super.key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isShadowVisible!
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, top: 0),
                child: CachedNetworkImage(
                  imageUrl: food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/app_logo.png',
                    color: Colors.grey,
                  ),
                  width: double.infinity,
                  height: 120,
                  memCacheHeight: 100,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: Text(
              '${food.name}',
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: '${food.weight}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                children: [
                  TextSpan(
                    text: ' - ${food.price} сом',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (isCounter == true)
            Container(
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
                    splashRadius: 20,
                    iconSize: 20,
                    onPressed: () {
                      if (quantity > 1) {
                        context.read<CartCubit>().decrementCart(food.id!);
                      } else {
                        context.read<CartCubit>().removeFromCart(food.id!);
                      }
                    },
                    icon: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Icon(Icons.remove),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Text('$quantity', style: theme.textTheme.bodyMedium),
                  ),
                  IconButton(
                    splashRadius: 20,
                    iconSize: 20,
                    onPressed: () {
                      if (quantity == 0) {
                        context.read<CartCubit>().addToCart(
                              CartItemModel(food: food, quantity: 1),
                            );
                      } else {
                        context.read<CartCubit>().incrementCart(food.id!);
                      }
                    },
                    icon: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}
