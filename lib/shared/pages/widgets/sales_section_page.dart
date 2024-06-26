import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/home_features/presentation/cubit/home_features_cubit.dart';

class SalesSection extends StatefulWidget {
  const SalesSection({super.key});

  @override
  SalesSectionState createState() => SalesSectionState();
}

class SalesSectionState extends State<SalesSection> {
  int _currentIndex = 0;

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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.sales,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.black1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        itemCount: sales.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () {
                              context.pushRoute(SaleRoute(sale: sales[index]));
                            },
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: sales[index].photoLink ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      "assets/images/app_icon.png",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '${sales[index].name} - ${sales[index].discount}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sales.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => CarouselSlider.builder(
                            options: CarouselOptions(
                              initialPage: entry.key,
                              aspectRatio: 16 / 9,
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 1.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            itemCount: sales.length,
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  context
                                      .pushRoute(SaleRoute(sale: sales[index]));
                                },
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: sales[index].photoLink ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          "assets/images/app_icon.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          '${sales[index].name} - ${sales[index].discount}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _currentIndex == entry.key ? 0.9 : 0.4),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
        }
        return const SizedBox();
      },
    );
  }
}
