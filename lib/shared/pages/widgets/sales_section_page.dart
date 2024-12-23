// ignore_for_file: avoid-returning-widgets

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesSection extends StatelessWidget {
  const SalesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeFeaturesCubit, HomeFeaturesState>(
      builder: (context, state) {
        if (state is GetSalesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetSalesError) {
          return Center(child: Text(state.message));
        } else if (state is GetSalesLoaded) {
          final sales = state.sales;
          return sales.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSalesCarousel(sales, context),
                    const SizedBox(height: 20),
                  ],
                );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSalesCarousel(List<SaleModel> sales, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: SizedBox(
        height: 250,
        child: PageView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return SaleCard(sale: sale);
          },
        ),
      ),
    );
  }
}

class SaleCard extends StatelessWidget {
  final SaleModel sale;

  const SaleCard({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        _buildImage(sale.photoLink),
        _buildTextOverlay(context, sale, theme),
      ],
    );
  }

  Widget _buildImage(String? photoLink) {
    return CachedNetworkImage(
      imageUrl: photoLink ?? '',
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/app_icon.png",
        fit: BoxFit.cover,
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTextOverlay(
      BuildContext context, SaleModel sale, ThemeData theme) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sale.name ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${sale.discount}% скидка',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(SaleRoute(sale: sale));
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: Text(
                  'Подробнее',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
