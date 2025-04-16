import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/components/components.dart';
import 'package:diyar/core/theme/theme.dart';
import '../../../core/router/routes.gr.dart';
import '../../../features/cart/data/models/cart_item_model.dart';
import '../../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../../features/features.dart';
import '../../../features/profile/presentation/presentation.dart';
import '../../../l10n/l10n.dart';
import '../../cubit/popular_cubit.dart';
import '../widgets/news_widget.dart';
import '../../shared.dart';
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
    _initializeData();
  }

  Future<void> _initializeData() async {
    final popularCubit = context.read<PopularCubit>();
    final cartCubit = context.read<CartCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final homeFeaturesCubit = context.read<HomeFeaturesCubit>();

    await popularCubit.getPopularProducts();

    if (mounted) {
      await cartCubit.getCartItems();
    }

    profileCubit.getUser();
    homeFeaturesCubit.getSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _HomeAppBar(),
      body: SafeArea(
        child: BlocConsumer<PopularCubit, PopularState>(
          listener: (context, state) {
            if (state is PopularError) {
              _showErrorSnackbar(context, state.message);
            } else if (state is PopularLoaded) {
              setState(() {
                menu = state.products;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SalesSection(),
                  const SizedBox(height: 10),
                  if (menu.isNotEmpty) _PopularSection(menu: menu),
                  const SizedBox(height: 20),
                  const _AboutUsSection(),
                  const SizedBox(height: 10),
                  const _NewsSection(),
                  const SizedBox(height: 20),
                  const _ContactTile(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.primary,
      title: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final userName =
              context.read<ProfileCubit>().user?.name ?? 'в Дияр Экспресс';
          return Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: Text(
                '${l10n.welcome}, $userName!',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: AppColors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PopularSection extends StatelessWidget {
  final List<FoodModel> menu;

  const _PopularSection({required this.menu});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.popularFood,
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 220,
          child: StreamBuilder<List<CartItemModel>>(
            stream: context.read<CartCubit>().cart,
            builder: (context, snapshot) {
              final cart = snapshot.data ?? [];
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: menu.length,
                controller: PageController(viewportFraction: 0.6),
                itemBuilder: (context, index) {
                  final food = menu[index];
                  final cartItem = cart.firstWhere(
                    (element) => element.food?.id == food.id,
                    orElse: () => CartItemModel(food: food, quantity: 0),
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
    );
  }
}

class _AboutUsSection extends StatelessWidget {
  const _AboutUsSection();

  @override
  Widget build(BuildContext context) {
    return AboutUsWidget(
      image: 'assets/images/about.png',
      onTap: () => context.router.push(const AboutUsRoute()),
    );
  }
}

class _NewsSection extends StatelessWidget {
  const _NewsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NewsWidgets(
      subtitle: l10n.news,
      title: 'Дияр',
      image: 'assets/images/news_da.png',
      onTap: () => context.router.push(const NewsRoute()),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SettingsTile(
        leading: const Icon(Icons.phone),
        text: l10n.contact,
        onPressed: () => context.router.push(const ContactRoute()),
      ),
    );
  }
}
