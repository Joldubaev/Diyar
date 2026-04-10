import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_card_constants.dart';
import 'product_counter_section.dart';
import 'product_image_section.dart';
import 'product_info_section.dart';

class ProductItemContentWidget extends StatefulWidget {
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

class _ProductItemContentWidgetState extends State<ProductItemContentWidget> with TickerProviderStateMixin {
  late final AnimationController _overlayController;
  late final Animation<double> _overlayOpacity;
  Timer? _fadeOutTimer;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: ProductCardConstants.overlayFadeInDuration,
      vsync: this,
    );
    _overlayOpacity = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(ProductItemContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCounter && oldWidget.quantity != widget.quantity && widget.quantity > 0) {
      _triggerOverlay();
    }
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _fadeOutTimer?.cancel();
    super.dispose();
  }

  void _triggerOverlay() {
    _overlayController.forward(from: 0.0);
    _fadeOutTimer?.cancel();
    _fadeOutTimer = Timer(ProductCardConstants.overlayVisibleDuration, () {
      if (mounted && _overlayController.status != AnimationStatus.dismissed) {
        _overlayController.reverse();
      }
    });
  }

  void _handleCartAction({required bool isIncrement}) {
    if (!UserHelper.isAuth()) {
      _showRegisterDialog();
      return;
    }
    final cartBloc = context.read<CartBloc>();
    final foodId = widget.food.id;
    if (foodId == null) return;

    if (isIncrement) {
      if (widget.quantity == 0) {
        cartBloc.add(AddItemToCart(
          CartItemEntity(food: widget.food, quantity: 1),
        ));
      } else {
        cartBloc.add(IncrementItemQuantity(foodId));
      }
    } else {
      if (widget.quantity > 1) {
        cartBloc.add(DecrementItemQuantity(foodId));
      } else if (widget.quantity == 1) {
        cartBloc.add(RemoveItemFromCart(foodId));
      }
    }
  }

  void _showRegisterDialog() {
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
      _showRegisterDialog();
      return;
    }
    final foodId = widget.food.id;
    if (foodId == null || newQuantity <= 0) return;
    context.read<CartBloc>().add(
          SetItemCount(CartItemEntity(food: widget.food, quantity: newQuantity)),
        );
  }

  /// Размер превью для [isCompact]: квадрат, ограниченный [ProductCardConstants.compactImageMaxSide].
  ({double width, double height}) _imageSizeCompact(double cardW) {
    final hPad = ProductCardConstants.cardPadding.horizontal;
    final inner = cardW - hPad;
    final side = math.max(
      ProductCardConstants.compactImageMinSide,
      math.min(inner, ProductCardConstants.compactImageMaxSide),
    );
    return (width: side, height: side);
  }

  BoxDecoration _cardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(
        ProductCardConstants.cardBorderRadius,
      ),
      boxShadow: widget.isShadowVisible
          ? [
              BoxShadow(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                spreadRadius: 0.5,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ]
          : null,
    );
  }

  /// Сетка меню: фото в [Expanded] — при нехватке места сжимается картинка, без RenderFlex overflow.
  Widget _buildCardGrid(ThemeData theme) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 0.85,
      maxScaleFactor: 1.2,
      child: DecoratedBox(
        decoration: _cardDecoration(theme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Квадрат по меньшей стороне: иначе tall Expanded + contain даёт мелкое фото и полосы.
                  final hPad = ProductCardConstants.cardPadding.horizontal;
                  final vPad = ProductCardConstants.cardPadding.vertical;
                  final innerW = (constraints.maxWidth - hPad).clamp(48.0, 400.0);
                  final innerH = math.max(40.0, constraints.maxHeight - vPad);
                  final side = math.min(innerW, innerH);
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ProductImageSection(
                      food: widget.food,
                      onTap: widget.onTap,
                      overlayOpacityAnimation: _overlayOpacity,
                      quantity: widget.quantity,
                      imageWidth: side,
                      imageHeight: side,
                      isCompact: false,
                      imageBoxFit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            ProductInfoSection(food: widget.food, isCompact: false, dense: true),
            if (widget.isCounter)
              ProductCounterSection(
                quantity: widget.quantity,
                onDecrement: () => _handleCartAction(isIncrement: false),
                onIncrement: () => _handleCartAction(isIncrement: true),
                onQuantityChanged: _handleQuantityChanged,
                isCompact: false,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// [fillVerticalSpace] — когда карточке задана явная высота: [Spacer] прижимает счётчик вниз.
  /// Для masonry («Популярные блюда») высота не фиксируется — иначе при крупном тексте [RenderFlex] overflow.
  Widget _buildCardCompact(
    ThemeData theme,
    double imgW,
    double imgH, {
    required bool fillVerticalSpace,
  }) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 0.85,
      maxScaleFactor: 1.2,
      child: DecoratedBox(
        decoration: _cardDecoration(theme),
        child: Column(
          mainAxisSize: fillVerticalSpace ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProductImageSection(
              food: widget.food,
              onTap: widget.onTap,
              overlayOpacityAnimation: _overlayOpacity,
              quantity: widget.quantity,
              imageWidth: imgW,
              imageHeight: imgH,
              isCompact: true,
              imageBoxFit: BoxFit.contain,
            ),
            ProductInfoSection(food: widget.food, isCompact: true, dense: true),
            if (fillVerticalSpace) const Spacer(),
            if (widget.isCounter)
              ProductCounterSection(
                quantity: widget.quantity,
                onDecrement: () => _handleCartAction(isIncrement: false),
                onIncrement: () => _handleCartAction(isIncrement: true),
                onQuantityChanged: _handleQuantityChanged,
                isCompact: true,
              ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.width != null && widget.height != null) {
      final w = widget.width!;
      final h = widget.height!;
      if (widget.isCompact) {
        final d = _imageSizeCompact(w);
        return SizedBox(
          width: w,
          height: h,
          child: _buildCardCompact(theme, d.width, d.height, fillVerticalSpace: true),
        );
      }
      return SizedBox(
        width: w,
        height: h,
        child: _buildCardGrid(theme),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultW = widget.width ?? (widget.isCompact ? 140.0 : ProductCardConstants.imageWidth);
        final defaultH = widget.height ?? (widget.isCompact ? 180.0 : 220.0);
        final cardW = constraints.maxWidth.isFinite ? constraints.maxWidth : defaultW;
        var cardH = defaultH;
        if (constraints.maxHeight.isFinite && defaultH > constraints.maxHeight) {
          cardH = constraints.maxHeight;
        }
        if (widget.isCompact) {
          final d = _imageSizeCompact(cardW);
          return SizedBox(
            width: cardW,
            child: _buildCardCompact(theme, d.width, d.height, fillVerticalSpace: false),
          );
        }
        return SizedBox(
          width: cardW,
          height: cardH,
          child: _buildCardGrid(theme),
        );
      },
    );
  }
}
