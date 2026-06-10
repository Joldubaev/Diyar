import 'dart:async';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/menu/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProductImage extends StatefulWidget {
  const ProductImage({
    super.key,
    required this.food,
    required this.quantity,
    this.fit = BoxFit.cover,
    this.blurFill = false,
    this.smartFit = false,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final FoodEntity food;
  final int quantity;
  final BoxFit fit;

  /// При true фон заполняется размытой копией того же фото (cover),
  /// поверх — само фото в [fit] (обычно contain).
  final bool blurFill;

  /// При true фит выбирается автоматически по аспекту фото:
  /// квадрат/почти квадрат → cover, портрет/ландшафт → contain.
  /// До определения аспекта используется [fit].
  final bool smartFit;

  /// Размер декодирования в пикселях устройства; если null — 400×400.
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Timer? _timer;
  BoxFit? _autoFit;
  ImageStream? _resolvingStream;
  ImageStreamListener? _resolvingListener;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    if (widget.smartFit) _resolveAutoFit();
  }

  void _resolveAutoFit() {
    final url = widget.food.imageUrlForList;
    if (url == null || url.isEmpty) return;
    final provider = CachedNetworkImageProvider(url);
    final stream = provider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener(
      (info, _) {
        final aspect = info.image.width / info.image.height;
        if (mounted) {
          setState(() {
            _autoFit = (aspect >= 0.85 && aspect <= 1.2) ? BoxFit.cover : BoxFit.contain;
          });
        }
      },
      onError: (_, __) {},
    );
    stream.addListener(listener);
    _resolvingStream = stream;
    _resolvingListener = listener;
  }

  @override
  void didUpdateWidget(ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity && widget.quantity > 0) {
      _controller.forward(from: 0);
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 400), () {
        if (mounted && _controller.status != AnimationStatus.dismissed) {
          _controller.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    if (_resolvingStream != null && _resolvingListener != null) {
      _resolvingStream!.removeListener(_resolvingListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final memW = widget.memCacheWidth ?? 800;
    final effectiveFit = widget.smartFit ? (_autoFit ?? BoxFit.cover) : widget.fit;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushRoute(ProductDetailRoute(food: widget.food)),
          borderRadius: BorderRadius.circular(10.0),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.06),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: theme.colorScheme.surface,
                child: CachedNetworkImage(
                  imageUrl:
                      widget.food.imageUrlForDetail ?? widget.food.imageUrlForList ?? 'https://via.placeholder.com/150',
                  placeholder: (_, __) => Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 2.0,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Column(
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
                  memCacheWidth: memW,
                  filterQuality: FilterQuality.high,
                  cacheManager: DefaultCacheManager(),
                  fit: effectiveFit,
                  alignment: Alignment.center,
                  imageBuilder: widget.blurFill
                      ? (context, imageProvider) => Stack(
                            fit: StackFit.expand,
                            children: [
                              ImageFiltered(
                                imageFilter: ui.ImageFilter.blur(
                                  sigmaX: 6,
                                  sigmaY: 6,
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  colorBlendMode: BlendMode.srcATop,
                                ),
                              ),
                              Image(
                                image: imageProvider,
                                fit: effectiveFit,
                              ),
                            ],
                          )
                      : null,
                ),
              ),
              FadeTransition(
                opacity: _opacity,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.75),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.quantity}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
