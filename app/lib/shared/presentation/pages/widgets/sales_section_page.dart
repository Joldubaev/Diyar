import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSection extends StatelessWidget {
  static const double _carouselHeight = 250.0;
  static const double _borderRadius = 20.0;
  static const double _defaultPadding = 16.0;
  static const double _overlayOpacity = 0.8;

  const SalesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      builder: (context, state) {
        return switch (state) {
          GetSalesLoading() => _buildLoadingState(),
          HomeContentError() => _buildErrorState(context, state.message),
          GetSalesLoaded() => _buildLoadedState(context, state.sales),
          _ => const SizedBox(),
        };
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(_defaultPadding),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Не удалось загрузить акции',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => context.read<HomeContentCubit>().getSales(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Обновить',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<SaleEntity> sales) {
    if (sales.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildSalesCarousel(sales),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSalesCarousel(List<SaleEntity> sales) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(_borderRadius),
      ),
      child: SizedBox(
        height: _carouselHeight,
        child: PageView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) => SaleCard(sale: sales[index]),
        ),
      ),
    );
  }
}

class SaleCard extends StatelessWidget {
  static const double _cardHeight = SalesSection._carouselHeight;
  static const double _overlaySpacing = 20.0;
  static const double _buttonRadius = 8.0;

  final SaleEntity sale;

  const SaleCard({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImage(),
        _buildTextOverlay(context, theme),
      ],
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: sale.photoLink ?? '',
      fit: BoxFit.cover,
      width: double.infinity,
      height: _cardHeight,
      errorWidget: (context, url, error) => _buildImageError(context),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildImageError(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'Изображение недоступно',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextOverlay(BuildContext context, ThemeData theme) {
    return Positioned(
      bottom: _overlaySpacing,
      left: _overlaySpacing,
      right: _overlaySpacing,
      child: Container(
        padding: const EdgeInsets.all(SalesSection._defaultPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withAlpha((SalesSection._overlayOpacity * 255).round()),
          borderRadius: const BorderRadius.all(
            Radius.circular(_buttonRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(theme),
            const SizedBox(height: 5),
            _buildDiscount(theme),
            const SizedBox(height: 10),
            _buildDetailsButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      sale.name ?? 'Акция',
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildDiscount(ThemeData theme) {
    return Text(
      '${sale.discount}% скидка',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context, ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton(
        onPressed: () => context.router.push(SaleRoute(sale: sale)),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
        child: Text(
          'Подробнее',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
