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
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset('assets/images/banner.png'),
    );
  }

  Widget _buildLoadedState(BuildContext context, List<SaleEntity> sales) {
    if (sales.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            _defaultPadding,
            _defaultPadding,
            _defaultPadding,
            _defaultPadding / 2,
          ),
          child: Text(
            'Акции',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
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
  static const double _buttonRadius = 8.0;

  final SaleEntity sale;

  const SaleCard({
    super.key,
    required this.sale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildInfoTextOverlay(context, theme, constraints),
            _buildActionButton(context, theme),
          ],
        );
      },
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

  Widget _buildInfoTextOverlay(BuildContext context, ThemeData theme, BoxConstraints constraints) {
    return Positioned(
      top: SalesSection._defaultPadding,
      left: SalesSection._defaultPadding,
      bottom: SalesSection._defaultPadding,
      width: constraints.maxWidth * 0.55, // Adjust width factor as needed
      child: Container(
        padding: const EdgeInsets.all(SalesSection._defaultPadding / 2), // Reduced padding a bit
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6), // Darker overlay for white text
          borderRadius: BorderRadius.circular(_buttonRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sale.name ?? 'Название акции',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary, // Assuming primary is orange
                fontWeight: FontWeight.bold,
              ),
              maxLines: 3, // Increased max lines
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6), // Adjusted spacing
            Text(
              '${sale.discount ?? 0}% скидка',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white, // White text for better contrast on dark overlay
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return Positioned(
      bottom: SalesSection._defaultPadding,
      right: SalesSection._defaultPadding,
      child: ElevatedButton(
        onPressed: () => context.router.push(SaleRoute(sale: sale)),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface, // Typically white
          foregroundColor: theme.colorScheme.primary, // Orange text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SalesSection._defaultPadding,
            vertical: SalesSection._defaultPadding / 2, // Adjusted vertical padding
          ),
        ),
        child: Text(
          'Подробнее',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
