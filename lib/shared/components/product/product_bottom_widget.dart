import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/shared/components/buttons/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBottomWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool? isCounter;
  final bool? isShadowVisible;
  final int quantity;
  final FoodModel food;

  const ProductBottomWidget({
    Key? key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl:
                    food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/app_logo.png',
                  color: Colors.grey,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                memCacheWidth: 1080,
                memCacheHeight: 810,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                child: Text(
                  '${food.name}',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
              SubmitButtonWidget(
                title: 'Добавить в корзину',
                bgColor: theme.primaryColor,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                onTap: () {
                  context.read<CartCubit>().addToCart(
                        CartItemModel(food: food, quantity: 1),
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
