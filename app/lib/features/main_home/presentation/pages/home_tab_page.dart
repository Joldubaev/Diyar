import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart' show showAddressConfirmBottomSheet;
import 'package:diyar/common/components/text/row_text_widget.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/active_order/presentation/widgets/banner_content_widget.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_app_bar.dart';
import 'profile_navigation_scope.dart';

@RoutePage()
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  String? _savedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
    _checkAddressConfirmation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHome());
  }

  /// Единственная точка загрузки данных главной — через HomeContentCubit и UseCase.
  Future<void> _loadHome() async {
    if (!mounted) return;
    final isAuth = UserHelper.isAuth();
    await context.read<HomeContentCubit>().loadHome(
          loadActiveOrders: isAuth,
          loadProfile: isAuth,
        );
  }

  void _loadSavedAddress() {
    setState(() {
      _savedAddress = sl<AddressStorageService>().getAddress();
    });
  }

  Future<void> _checkAddressConfirmation() async {
    final addressStorage = sl<AddressStorageService>();
    if (!addressStorage.shouldShowAddressConfirmation()) return;

    final address = addressStorage.getAddress();
    if (address == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final result = await showAddressConfirmBottomSheet(context, address: address);

      if (!mounted) return;
      if (result == true) {
        await addressStorage.confirmAddress();
      } else if (result == false) {
        context.router.push(const AddressSelectionRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: HomeAppBar(
        savedAddress: _savedAddress,
        onAddressTap: () async {
          await context.router.push(const AddressSelectionRoute());
          if (mounted) _loadSavedAddress();
        },
        onProfileTap: () async {
          final scope = ProfileNavigationScope.maybeOf(context);
          final canGo = await scope?.navigateToProfileOrRequireAuth() ?? false;
          if (canGo && context.mounted) {
            AutoTabsRouter.of(context).setActiveIndex(3);
          }
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHome,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StoriesSection(),
                const _ActiveOrdersSection(),
                const _BonusCardSection(),
                const SizedBox(height: 20),
                _PopularFoodSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- ОТДЕЛЬНЫЕ ВИДЖЕТЫ ЭКРАНА ---

class _StoriesSection extends StatelessWidget {
  const _StoriesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) =>
          curr is HomeContentLoading || curr is HomeContentLoaded || curr is GetNewsLoaded || curr is GetNewsLoading,
      builder: (context, state) {
        if (state is HomeContentLoading || state is GetNewsLoading) {
          return const SizedBox(height: 115);
        }

        final news = state is HomeContentLoaded
            ? state.news
            : state is GetNewsLoaded
                ? state.news
                : <NewsEntity>[];
        if (news.isEmpty) return const SizedBox.shrink();

        final items = news
            .where((e) => e.photoLink?.isNotEmpty ?? false)
            .toList()
            .asMap()
            .entries
            .map((e) => DiyarStoryItem(
                  id: e.value.id ?? e.key.toString(),
                  cardImageLink: e.value.photoLink!,
                  cardLabel: e.value.name ?? '',
                  storyPagesImages: [e.value.photoLink!],
                  storyPageDuration: const [Duration(seconds: 5)],
                ))
            .toList();

        return items.isEmpty ? const SizedBox.shrink() : MqStoryItemsWidget(items: items);
      },
    );
  }
}

class _BonusCardSection extends StatelessWidget {
  const _BonusCardSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) =>
          curr is HomeContentLoading || curr is HomeContentLoaded,
      builder: (context, state) {
        final profile = state is HomeContentLoaded ? state.profile : null;
        return BonusCardWidget(profile: profile);
      },
    );
  }
}

class _ActiveOrdersSection extends StatelessWidget {
  const _ActiveOrdersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) => curr is HomeContentLoading || curr is HomeContentLoaded,
      builder: (context, state) {
        if (state is! HomeContentLoaded || state.activeOrders.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BannerContent(
            ordersCount: state.activeOrders.length,
            onTap: () => context.router.push(const ActiveOrderRoute()),
          ),
        );
      },
    );
  }
}

class _PopularFoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeContentCubit, HomeContentState>(
      buildWhen: (prev, curr) => curr is HomeContentLoading || curr is HomeContentLoaded,
      builder: (context, state) {
        final isLoading = state is HomeContentLoading;
        final products = state is HomeContentLoaded ? state.popularProducts : <FoodEntity>[];

        final theme = Theme.of(context);
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowTextWidget(text: context.l10n.popularFood, theme: context.theme),
              if (isLoading)
                const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              if (!isLoading && products.isNotEmpty) PopularFoodSectionWidget(menu: products),
            ],
          ),
        );
      },
    );
  }
}
