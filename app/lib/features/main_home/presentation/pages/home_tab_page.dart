import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/components/components.dart' show showAddressConfirmBottomSheet;
import 'package:diyar/common/components/text/row_text_widget.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
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
    _initializeData();
    _loadSavedAddress();
    _checkAddressConfirmation();
  }

  // --- Логика инициализации ---
  Future<void> _initializeData() async {
    context.read<PopularCubit>().getPopularProducts();
    context.read<ProfileCubit>().getUser();
    context.read<HomeContentCubit>().getSales();
    context.read<HomeContentCubit>().getNews();
    if (UserHelper.isAuth()) {
      context.read<ActiveOrderCubit>().getActiveOrders();
    }
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
          onRefresh: _initializeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StoriesSection(),
                const _ActiveOrdersSection(),
                const BonusCardWidget(),
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
      buildWhen: (_, current) => current is GetNewsLoaded || current is GetNewsLoading,
      builder: (context, state) {
        if (state is GetNewsLoading) return const SizedBox(height: 115);

        if (state is GetNewsLoaded && state.news.isNotEmpty) {
          final items = state.news
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
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ActiveOrdersSection extends StatelessWidget {
  const _ActiveOrdersSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveOrderCubit, ActiveOrderState>(
      buildWhen: (_, current) => current is ActiveOrdersLoaded || current is ActiveOrdersLoading,
      builder: (context, state) {
        if (state is ActiveOrdersLoaded && state.orders.isNotEmpty) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: ActiveOrdersBannerWidget(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PopularFoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PopularCubit, PopularState>(
      listener: (context, state) {
        if (state is PopularError) context.showSnack(state.message, isError: true);
      },
      builder: (context, state) {
        final products = state is PopularLoaded ? state.products : <FoodEntity>[];
        final isLoading = state is PopularLoading;

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
