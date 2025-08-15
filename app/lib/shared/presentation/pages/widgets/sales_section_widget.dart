import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/home_content/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSectionWidget extends StatefulWidget {
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
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Адаптивная высота в зависимости от ширины экрана
                  final screenWidth = MediaQuery.of(context).size.width;
                  final carouselHeight = screenWidth > 600
                      ? screenWidth * 0.25 // Для планшетов
                      : screenWidth * 0.4; // Для телефонов

                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(SalesSectionWidget._borderRadius)),
                    child: SizedBox(
                      height: carouselHeight.clamp(120.0, 200.0), // Минимум 120, максимум 200
                      child: PageView.builder(
                        itemCount: state.sales.length,
                        itemBuilder: (context, index) => SaleCard(
                          sale: state.sales[index],
                          cardHeight: carouselHeight.clamp(120.0, 200.0),
                        ),
                      ),
                    ),
                  );
                },
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
  static const double _buttonRadius = 8.0;
  static const double _defaultPadding = SalesSectionWidget._defaultPadding;

  final SaleEntity sale;
  final double cardHeight;

  const SaleCard({super.key, required this.sale, required this.cardHeight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Адаптивные размеры в зависимости от высоты карточки
    final isSmallCard = cardHeight < 150;
    final adaptivePadding = isSmallCard ? _defaultPadding * 0.75 : _defaultPadding;
    final containerWidth = screenWidth * (isSmallCard ? 0.65 : 0.6);

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: sale.photoLink ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: cardHeight,
          errorWidget: (context, url, error) => _ImageError(),
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        ),
        Positioned(
          top: adaptivePadding,
          left: adaptivePadding,
          bottom: adaptivePadding,
          child: Container(
            width: containerWidth,
            padding: EdgeInsets.all(adaptivePadding * 0.5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(_buttonRadius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    sale.name ?? 'Название акции',
                    style: _getAdaptiveTitleStyle(theme, isSmallCard),
                    maxLines: isSmallCard ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isSmallCard ? 2 : 4),
                Text(
                  '${sale.discount ?? 0}% скидка',
                  style: _getAdaptiveSubtitleStyle(theme, isSmallCard),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: adaptivePadding,
          right: adaptivePadding,
          child: ElevatedButton(
            onPressed: () => context.router.push(SaleRoute(sale: sale)),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(_buttonRadius)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: adaptivePadding * (isSmallCard ? 0.75 : 1),
                vertical: adaptivePadding * 0.5,
              ),
              minimumSize: Size(0, isSmallCard ? 32 : 36),
            ),
            child: Text(
              'Подробнее',
              style: _getAdaptiveButtonStyle(theme, isSmallCard),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle? _getAdaptiveTitleStyle(ThemeData theme, bool isSmallCard) {
    return isSmallCard
        ? theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
        : theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          );
  }

  TextStyle? _getAdaptiveSubtitleStyle(ThemeData theme, bool isSmallCard) {
    return isSmallCard
        ? theme.textTheme.bodyMedium?.copyWith(color: Colors.white)
        : theme.textTheme.titleMedium?.copyWith(color: Colors.white);
  }

  TextStyle? _getAdaptiveButtonStyle(ThemeData theme, bool isSmallCard) {
    return isSmallCard
        ? theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          )
        : theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
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
