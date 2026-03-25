import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// --- Main Widget ---
class ProductItemContentWidget extends StatefulWidget {
  // --- Constants ---
  static const double _cardBorderRadius = 10.0;

  /// Запас под текст, счётчик и отступы карточки — высота фото не должна его превышать.
  static const double _reservedBelowImage = 95.0;
  static const double _imageWidth = 170.0;
  static const int _memCacheWidth = 400;
  static const int _memCacheHeight = 400;
  static const double _counterHeight = 35.0;
  static const double _counterBorderRadius = 30.0;
  static const Duration _overlayFadeInDuration = Duration(milliseconds: 150);
  static const Duration _overlayVisibleDuration = Duration(milliseconds: 400);
  static const EdgeInsets _cardPadding = EdgeInsets.all(4.0);
  static const EdgeInsets _infoPadding = EdgeInsets.symmetric(horizontal: 6.0);
  static const EdgeInsets _counterMargin = EdgeInsets.symmetric(horizontal: 10.0);

  // --- Properties ---
  final VoidCallback? onTap;
  final bool isCounter;
  final bool isShadowVisible;
  final int quantity;
  final FoodEntity food;
  final double? width;
  final double? height;
  final bool isCompact;

  const ProductItemContentWidget({
    super.key,
    this.onTap,
    this.isShadowVisible = true,
    required this.food,
    required this.quantity,
    this.isCounter = true,
    this.width,
    this.height,
    this.isCompact = false,
  });

  @override
  State<ProductItemContentWidget> createState() => _ProductItemContentWidgetState();
}

// --- State --- (Handles Animation and Actions)
class _ProductItemContentWidgetState extends State<ProductItemContentWidget> with TickerProviderStateMixin {
  late final AnimationController _overlayAnimationController;
  late final Animation<double> _overlayOpacityAnimation;
  Timer? _fadeOutTimer;

  @override
  void initState() {
    super.initState();
    _overlayAnimationController = AnimationController(
      duration: ProductItemContentWidget._overlayFadeInDuration,
      vsync: this,
    );
    _overlayOpacityAnimation = CurvedAnimation(
      parent: _overlayAnimationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(ProductItemContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCounter && oldWidget.quantity != widget.quantity && widget.quantity > 0) {
      _triggerOverlayAnimation();
    }
  }

  @override
  void dispose() {
    _overlayAnimationController.dispose();
    _fadeOutTimer?.cancel();
    super.dispose();
  }

  void _triggerOverlayAnimation() {
    _overlayAnimationController.forward(from: 0.0);
    _fadeOutTimer?.cancel();
    _fadeOutTimer = Timer(ProductItemContentWidget._overlayVisibleDuration, () {
      if (mounted && _overlayAnimationController.status != AnimationStatus.dismissed) {
        _overlayAnimationController.reverse();
      }
    });
  }

  void _handleCartAction({required bool isIncrement}) {
    if (!UserHelper.isAuth()) {
      _showRegisterDialog(context);
      return;
    }
    final cartBloc = context.read<CartBloc>();
    final currentQuantity = widget.quantity;
    final foodId = widget.food.id;
    if (foodId == null) return;

    if (isIncrement) {
      if (currentQuantity == 0) {
        cartBloc.add(AddItemToCart(CartItemEntity(food: widget.food, quantity: 1)));
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

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => RegistrationAlertDialog(
        onRegister: () {
          Navigator.of(context).pop();
          context.router.push(const SignInRoute());
        },
        onLogin: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _handleQuantityChanged(int newQuantity) {
    if (!UserHelper.isAuth()) {
      _showRegisterDialog(context);
      return;
    }
    final cartBloc = context.read<CartBloc>();
    final foodId = widget.food.id;
    if (foodId == null) return;

    if (newQuantity > 0) {
      cartBloc.add(SetItemCount(CartItemEntity(food: widget.food, quantity: newQuantity)));
    }
  }

  /// Область фото по ширине карточки и доступной высоте ячейки (не фиксированные 170×110),
  /// чтобы при [BoxFit.contain] квадратные фото не оставались «крошечными» по центру.
  ({double width, double height}) _imageSizeForCard({
    required double cardWidth,
    required double cardHeight,
    required bool isCompact,
  }) {
    if (isCompact) {
      return (width: 120.0, height: 80.0);
    }
    final w = (cardWidth - ProductItemContentWidget._cardPadding.horizontal).clamp(48.0, 400.0);
    final effectiveH = cardHeight.isFinite ? cardHeight : 220.0;
    final hAvail = (effectiveH - ProductItemContentWidget._reservedBelowImage).clamp(0.0, 400.0);
    if (hAvail <= 0) {
      return (width: w, height: 100.0);
    }
    final h = math.min(w, hAvail).clamp(96.0, w * 1.15);
    return (width: w, height: h);
  }

  Widget _buildCardBody(
    ThemeData theme, {
    required double imageWidth,
    required double imageHeight,
  }) {
    return DecoratedBox(
      decoration: _buildCardDecoration(context, theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProductImageSection(
            food: widget.food,
            onTap: widget.onTap,
            overlayOpacityAnimation: _overlayOpacityAnimation,
            quantity: widget.quantity,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            isCompact: widget.isCompact,
          ),
          _ProductInfoSection(
            food: widget.food,
            isCompact: widget.isCompact,
          ),
          const Spacer(),
          if (widget.isCounter)
            _ProductCounterSection(
              quantity: widget.quantity,
              onDecrement: () => _handleCartAction(isIncrement: false),
              onIncrement: () => _handleCartAction(isIncrement: true),
              onQuantityChanged: _handleQuantityChanged,
              isCompact: widget.isCompact,
            ),
          SizedBox(height: widget.isCompact ? 4 : 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.width != null && widget.height != null) {
      final dims = _imageSizeForCard(
        cardWidth: widget.width!,
        cardHeight: widget.height!,
        isCompact: widget.isCompact,
      );
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildCardBody(theme, imageWidth: dims.width, imageHeight: dims.height),
      );
    }

    // В GridView/списках — подстраиваем размеры под доступные ограничения, избегая бесконечных значений
    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultWidth = widget.width ?? (widget.isCompact ? 140.0 : ProductItemContentWidget._imageWidth);
        final defaultHeight = widget.height ?? (widget.isCompact ? 180.0 : 220.0);

        final cardWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : defaultWidth;

        double cardHeight = defaultHeight;
        if (constraints.maxHeight.isFinite) {
          if (defaultHeight > constraints.maxHeight) {
            cardHeight = constraints.maxHeight;
          }
        }

        final dims = _imageSizeForCard(
          cardWidth: cardWidth,
          cardHeight: cardHeight,
          isCompact: widget.isCompact,
        );

        return SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: _buildCardBody(theme, imageWidth: dims.width, imageHeight: dims.height),
        );
      },
    );
  }

  BoxDecoration _buildCardDecoration(BuildContext context, ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.all(Radius.circular(ProductItemContentWidget._cardBorderRadius)),
      boxShadow: widget.isShadowVisible
          ? [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                spreadRadius: 0.5,
                blurRadius: 4,
                offset: const Offset(0, 1),
              )
            ]
          : null,
    );
  }
}

// --- Section Widgets ---

// Widget for Image Area (including overlay)
class _ProductImageSection extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback? onTap;
  final Animation<double> overlayOpacityAnimation;
  final int quantity;
  final double imageWidth;
  final double imageHeight;
  final bool isCompact;

  const _ProductImageSection({
    required this.food,
    this.onTap,
    required this.overlayOpacityAnimation,
    required this.quantity,
    required this.imageWidth,
    required this.imageHeight,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: ProductItemContentWidget._cardPadding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(ProductItemContentWidget._cardBorderRadius)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: imageWidth,
                height: imageHeight,
                color: theme.colorScheme.surface,
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: food.urlPhoto ?? 'https://via.placeholder.com/150',
                  placeholder: (context, url) => _buildImagePlaceholder(theme),
                  errorWidget: (context, url, error) => _buildImageError(theme),
                  width: imageWidth,
                  height: imageHeight,
                  memCacheWidth: ProductItemContentWidget._memCacheWidth,
                  memCacheHeight: ProductItemContentWidget._memCacheHeight,
                  cacheManager: DefaultCacheManager(),
                  // Вся картинка в кадре без обрезки; поля по краям совпадают с фоном карточки.
                  fit: BoxFit.contain,
                ),
              ),
              _buildQuantityOverlay(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityOverlay(ThemeData theme) {
    return Positioned.fill(
      child: FadeTransition(
        opacity: overlayOpacityAnimation,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.75),
            ),
            child: Center(
              child: Text(
                '$quantity',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      width: imageWidth,
      height: imageHeight,
      color: theme.colorScheme.surface.withValues(alpha: 0.5),
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildImageError(ThemeData theme) {
    return Container(
      width: imageWidth,
      height: imageHeight,
      color: theme.colorScheme.surface.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 4),
          Text(
            'Нет фото',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Text Info (Name, Weight, Price)
class _ProductInfoSection extends StatelessWidget {
  final FoodEntity food;
  final bool isCompact;

  const _ProductInfoSection({
    required this.food,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: ProductItemContentWidget._infoPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            food.name ?? 'Название блюда',
            style: theme.textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              text: food.weight ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                if (food.price != null)
                  TextSpan(
                    text: ' - ${food.price} сом',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Widget for Counter (Buttons and Quantity Text)
class _ProductCounterSection extends StatefulWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final ValueChanged<int>? onQuantityChanged;
  final bool isCompact;

  const _ProductCounterSection({
    required this.quantity,
    this.onDecrement,
    this.onIncrement,
    this.onQuantityChanged,
    this.isCompact = false,
  });

  @override
  State<_ProductCounterSection> createState() => _ProductCounterSectionState();
}

class _ProductCounterSectionState extends State<_ProductCounterSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant _ProductCounterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onFieldChanged(String value) {
    final int? newValue = int.tryParse(value);
    if (newValue != null && newValue > 0 && widget.onQuantityChanged != null) {
      widget.onQuantityChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: ProductItemContentWidget._counterHeight,
      margin: ProductItemContentWidget._counterMargin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(ProductItemContentWidget._counterBorderRadius)),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CounterButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 0 ? widget.onDecrement : null,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: _onFieldChanged,
            ),
          ),
          const SizedBox(width: 8),
          _CounterButton(
            icon: Icons.add,
            onPressed: widget.onIncrement,
          ),
        ],
      ),
    );
  }
}

// Helper Widget for Counter Buttons
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
    bool isEnabled = onPressed != null;

    return IconButton(
      splashRadius: 20,
      iconSize: 20,
      visualDensity: VisualDensity.compact,
      color: isEnabled ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.38),
      onPressed: onPressed,
      icon: Icon(icon),
      disabledColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
    );
  }
}
