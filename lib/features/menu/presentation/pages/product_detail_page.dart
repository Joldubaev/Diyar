import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/custom_dialog/custom_dialog.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/utils/helper/user_helper.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:diyar/shared/theme/app_colors.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  final int? quantity;
  final FoodModel food;

  const ProductDetailPage({
    super.key,
    required this.food,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () {
            context.router.maybePop();
          },
        ),
        title: Text(
          'Описание блюда',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProductImage(food: food),
            const SizedBox(height: 10),
            ProductName(food: food),
            ProductWeightAndPrice(food: food),
            ProductDescription(food: food),
            StreamBuilder<List<CartItemModel>>(
              stream: context.read<CartCubit>().cart,
              builder: (context, snapshot) {
                List cart = [];
                if (snapshot.hasData) {
                  cart = snapshot.data ?? [];
                }

                final cartItem = cart.firstWhere(
                  (element) => element.food?.id == food.id,
                  orElse: () => CartItemModel(food: food, quantity: 0),
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity! > 1) {
                          if (UserHelper.isAuth(
                            
                          )) {
                            context.read<CartCubit>().decrementCart(food.id!);
                          } else {
                            _showRegisterDialog(context);
                          }
                        } else {
                          if (UserHelper.isAuth()) {
                            context.read<CartCubit>().removeFromCart(food.id!);
                          } else {
                            _showRegisterDialog(context);
                          }
                        }
                      },
                    ),
                    Text(
                      "${cartItem.quantity}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (quantity == 0) {
                          if (UserHelper.isAuth()) {
                            context.read<CartCubit>().addToCart(
                                  CartItemModel(food: food, quantity: 1),
                                );
                          } else {
                            _showRegisterDialog(context);
                          }
                        } else {
                          if (UserHelper.isAuth()) {
                            context.read<CartCubit>().incrementCart(food.id!);
                          } else {
                            _showRegisterDialog(context);
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final FoodModel food;

  const ProductImage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/app_logo.png',
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      memCacheWidth: 410,
      memCacheHeight: 410,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ProductName extends StatelessWidget {
  final FoodModel food;

  const ProductName({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        food.name ?? 'Продукт',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ProductWeightAndPrice extends StatelessWidget {
  final FoodModel food;

  const ProductWeightAndPrice({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text.rich(
        TextSpan(
          text: food.weight ?? 'N/A',
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.onSurface),
          children: [
            TextSpan(
              text: ' - ${food.price ?? '0'} сом',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.green,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final FoodModel food;

  const ProductDescription({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        food.description ?? 'Описание отсутствует',
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.normal),
        textAlign: TextAlign.center,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

void _showRegisterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return RegistrationAlertDialog(
        onRegister: () {
          Navigator.of(context).pop();
          context.router.push(const SignInRoute());
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}
