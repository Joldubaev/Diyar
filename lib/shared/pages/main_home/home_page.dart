import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/sale_news/presentation/cubit/home_features_cubit.dart';
import 'package:diyar/features/profile/presentation/presentation.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/cubit/popular_cubit.dart';
import 'package:diyar/shared/pages/widgets/news_widget.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/sales_section_page.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodModel> menu = [];

  @override
  void initState() {
    super.initState();
    context.read<PopularCubit>().getPopularProducts().then((_) {
      context.read<CartCubit>().getCartItems().then((_) {});
    });
    context.read<ProfileCubit>().getUser();
    context.read<HomeFeaturesCubit>().getSales();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Text(
                  '${l10n.welcome},${context.read<ProfileCubit>().user?.name ?? 'В Дияр'}!',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PopularCubit, PopularState>(
          listener: (context, state) {
            if (state is PopularError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.primary,
                ),
              );
            } else if (state is PopularLoaded) {
              setState(() {
                menu = state.products;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SalesSection(),
                  const SizedBox(height: 10),
                  if (menu.isNotEmpty) ...[
                    Text(
                      l10n.popularFood,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.black1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: StreamBuilder<List<CartItemModel>>(
                        stream: context.read<CartCubit>().cart,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final cart = snapshot.data ?? [];
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemCount: menu.length,
                            controller: PageController(viewportFraction: 0.6),
                            itemBuilder: (context, index) {
                              final food = menu[index];
                              final cartItem = cart.firstWhere(
                                (element) => element.food?.id == food.id,
                                orElse: () =>
                                    CartItemModel(food: food, quantity: 0),
                              );

                              return SizedBox(
                                width: 200,
                                child: ProductItemWidget(
                                  food: food,
                                  quantity: cartItem.quantity ?? 0,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  AboutUsWidget(
                    image: 'assets/images/about.png',
                    onTap: () => context.router.push(const AboutUsRoute()),
                  ),
                  const SizedBox(height: 10),
                  NewsWidgets(
                    subtitle: l10n.news,
                    title: 'Дияр',
                    image: 'assets/images/news_da.png',
                    onTap: () => context.router.push(const NewsRoute()),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SettingsTile(
                      leading: const Icon(Icons.phone),
                      text: l10n.contact,
                      onPressed: () =>
                          context.router.push(const ContactRoute()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
