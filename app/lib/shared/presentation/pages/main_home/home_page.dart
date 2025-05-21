import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/theme/theme.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FoodEntity> menu = [];
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    context.read<PopularCubit>().getPopularProducts();
    context.read<ProfileCubit>().getUser();
    context.read<HomeContentCubit>().getSales();
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
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SalesSectionWidget(),
                  if (menu.isNotEmpty) PopularFoodSectionWidget(menu: menu),
                  AboutUsWidget(
                    image: 'assets/images/about.png',
                    onTap: () => context.router.push(const AboutUsRoute()),
                  ),
                  NewsWidgets(
                    subtitle: context.l10n.news,
                    title: 'Дияр',
                    image: 'assets/images/news_da.png',
                    onTap: () => context.router.push(const NewsRoute()),
                  ),
                  const ContactTileWidget(),
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
          final userName = context.read<ProfileCubit>().user?.userName ?? 'в Дияр Экспресс';
          return Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: Text(
                '${l10n.welcome}, $userName!',
                style: theme.textTheme.titleSmall?.copyWith(color: AppColors.white),
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
