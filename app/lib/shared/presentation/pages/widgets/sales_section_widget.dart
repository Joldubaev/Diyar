import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSectionWidget extends StatefulWidget {
  static const double _carouselHeight = 150.0;
  static const double _borderRadius = 20.0;
  static const double _defaultPadding = 16.0;

  const SalesSectionWidget({super.key});

  @override
  State<SalesSectionWidget> createState() => _SalesSectionWidgetState();
}

class _SalesSectionWidgetState extends State<SalesSectionWidget> with RouteAware {
  @override
  void didPopNext() {
    context.read<HomeContentCubit>().getSales();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      builder: (context, state) {
        if (state is GetSalesLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(SalesSectionWidget._defaultPadding),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is HomeContentError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Image.asset('assets/images/banner.png'),
          );
        }
        if (state is GetSalesLoaded && state.sales.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Акции',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(SalesSectionWidget._borderRadius)),
                child: SizedBox(
                  height: SalesSectionWidget._carouselHeight,
                  child: PageView.builder(
                    itemCount: state.sales.length,
                    itemBuilder: (context, index) => SaleCard(sale: state.sales[index]),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class SaleCard extends StatelessWidget {
  static const double _cardHeight = SalesSectionWidget._carouselHeight;
  static const double _buttonRadius = 8.0;
  static const double _defaultPadding = SalesSectionWidget._defaultPadding;

  final SaleEntity sale;

  const SaleCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: sale.photoLink ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: _cardHeight,
          errorWidget: (context, url, error) => _ImageError(),
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          top: _defaultPadding,
          left: _defaultPadding,
          bottom: _defaultPadding,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.55,
            padding: const EdgeInsets.all(_defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sale.name ?? 'Название акции',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${sale.discount ?? 0}% скидка',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: _defaultPadding,
          right: _defaultPadding,
          child: ElevatedButton(
            onPressed: () => context.router.push(SaleRoute(sale: sale)),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: _defaultPadding,
                vertical: _defaultPadding / 2,
              ),
            ),
            child: Text(
              'Подробнее',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'Изображение недоступно',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
