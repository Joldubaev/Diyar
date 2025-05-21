import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart';
import 'package:diyar/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class ProductDetailPage extends StatelessWidget {
  static const double _imageHeightFactor = 0.3;
  static const String _defaultImageUrl = 'https://i.ibb.co/GkL25DB/ALE-1357-7.png';
  static const EdgeInsets _defaultPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const Duration _animationDuration = Duration(milliseconds: 300);

  final int? quantity;
  final FoodEntity food;

  const ProductDetailPage({
    super.key,
    required this.food,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context, theme),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Hero(
                tag: 'food_image_${food.id}',
                child: ProductImage(food: food),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: _defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductName(food: food),
                    const SizedBox(height: 8),
                    ProductWeightAndPrice(food: food),
                    const SizedBox(height: 16),
                    ProductDescription(food: food),
                    const SizedBox(height: 24),
                    CartControls(food: food, quantity: quantity),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: () => context.router.maybePop(),
      ),
      title: Text(
        'Описание блюда',
        style: theme.textTheme.titleSmall!.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CartControls extends StatelessWidget {
  final FoodEntity food;
  final int? quantity;

  const CartControls({
    super.key,
    required this.food,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemQuantity = 0;
        CartItemEntity? cartItem;

        if (state is CartLoaded) {
          cartItem = state.items.firstWhere(
            (element) => element.food?.id == food.id,
            orElse: () => CartItemEntity(food: food, quantity: 0),
          );
          itemQuantity = cartItem.quantity ?? 0;
        } else if (state is CartLoading || state is CartInitial) {
          // Optionally show a loading indicator or disable buttons
          // For simplicity, we'll just show 0 and buttons might be disabled based on quantity
        } else if (state is CartError) {
          // Optionally show an error indicator
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterButton(
                icon: Icons.remove,
                onPressed: itemQuantity > 0
                    ? () => _handleCartAction(context, cartItem ?? CartItemEntity(food: food, quantity: 0),
                        isIncrement: false)
                    : null,
              ),
              SizedBox(
                width: 50,
                child: Text(
                  "$itemQuantity",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              _CounterButton(
                icon: Icons.add,
                onPressed: () =>
                    _handleCartAction(context, cartItem ?? CartItemEntity(food: food, quantity: 0), isIncrement: true),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleCartAction(BuildContext context, CartItemEntity cartItem, {required bool isIncrement}) {
    if (!UserHelper.isAuth()) {
      _showRegisterDialog(context);
      return;
    }

    final currentQuantity = cartItem.quantity ?? 0;
    final cartBloc = context.read<CartBloc>();
    final foodId = food.id;

    if (foodId == null) return;

    if (isIncrement) {
      if (currentQuantity == 0) {
        cartBloc.add(AddItemToCart(CartItemEntity(food: food, quantity: 1)));
      } else {
        cartBloc.add(IncrementItemQuantity(foodId));
      }
    } else {
      if (currentQuantity > 1) {
        cartBloc.add(DecrementItemQuantity(foodId));
      } else if (currentQuantity == 1) {
        cartBloc.add(RemoveItemFromCart(foodId));
      }
    }
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CounterButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;

    return Material(
      color: isEnabled ? theme.colorScheme.primary : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final FoodEntity food;

  const ProductImage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(context),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * ProductDetailPage._imageHeightFactor,
        child: CachedNetworkImage(
          imageUrl: food.urlPhoto ?? ProductDetailPage._defaultImageUrl,
          imageBuilder: (context, imageProvider) => _buildImage(imageProvider),
          errorWidget: (context, url, error) => _buildErrorWidget(context),
          placeholder: (context, url) => _buildLoadingWidget(),
          // memCacheWidth: 600,
          // memCacheHeight: 600,
        ),
      ),
    );
  }

  Widget _buildImage(ImageProvider imageProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Не удалось загрузить изображение',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  food.urlPhoto ?? ProductDetailPage._defaultImageUrl,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductName extends StatelessWidget {
  final FoodEntity food;

  const ProductName({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Text(
      food.name ?? 'Продукт',
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.left,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ProductWeightAndPrice extends StatelessWidget {
  final FoodEntity food;

  const ProductWeightAndPrice({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          food.weight ?? 'N/A',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        AnimatedDefaultTextStyle(
          duration: ProductDetailPage._animationDuration,
          style: theme.textTheme.titleMedium!.copyWith(
            color: AppColors.green,
            fontWeight: FontWeight.w600,
          ),
          child: Text('${food.price ?? '0'} сом'),
        ),
      ],
    );
  }
}

class ProductDescription extends StatelessWidget {
  final FoodEntity food;

  const ProductDescription({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        food.description ?? 'Описание отсутствует',
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              height: 1.5,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

void _showRegisterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => RegistrationAlertDialog(
      onRegister: () {
        Navigator.of(context).pop();
        context.router.push(const SignInRoute());
      },
      onCancel: () => Navigator.of(context).pop(),
    ),
  );
}
