import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:diyar/shared/theme/app_colors.dart';
import 'package:diyar/features/features.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isCounter;
  final bool isShadowVisible;
  final int quantity;
  final FoodModel food;
  final MenuRemoteDataSource? dataSource;

  const ProductDetailPage({
    Key? key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    this.quantity = 1,
    this.isCounter = true,
    this.dataSource,
  }) : super(key: key);

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
          children: [
            ProductImage(food: food),
            const SizedBox(height: 10),
            ProductName(food: food),
            ProductWeightAndPrice(food: food),
            ProductDescription(food: food),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final FoodModel food;

  const ProductImage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: food.urlPhoto ?? 'https://i.ibb.co/GkL25DB/ALE-1357-7.png',
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/app_logo.png',
        color: theme.colorScheme.onSurface.withOpacity(0.1),
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

  const ProductName({Key? key, required this.food}) : super(key: key);

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

  const ProductWeightAndPrice({Key? key, required this.food}) : super(key: key);

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

  const ProductDescription({Key? key, required this.food}) : super(key: key);

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
