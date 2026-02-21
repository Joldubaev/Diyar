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
  List<FoodEntity> menu = [];
  String? _savedAddress;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadSavedAddress();
    _checkAddressConfirmation();
  }

  Future<void> _initializeData() async {
    context.read<PopularCubit>().getPopularProducts();
    context.read<ProfileCubit>().getUser();
    context.read<HomeContentCubit>().getSales();
    if (UserHelper.isAuth()) {
      context.read<ActiveOrderCubit>().getActiveOrders();
    }
  }

  void _loadSavedAddress() {
    final addressStorage = sl<AddressStorageService>();
    setState(() {
      _savedAddress = addressStorage.getAddress();
    });
  }

  Future<void> _checkAddressConfirmation() async {
    final addressStorage = sl<AddressStorageService>();
    if (!addressStorage.shouldShowAddressConfirmation()) return;

    final address = addressStorage.getAddress();
    if (address == null) return;

    // Показываем после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final result = await showAddressConfirmBottomSheet(
        context,
        address: address,
      );

      if (!mounted) return;

      if (result == true) {
        // Подтвердить текущий адрес
        await addressStorage.confirmAddress();
      } else if (result == false) {
        // Изменить адрес — перейти на карту
        context.router.push(const AddressSelectionRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        savedAddress: _savedAddress,
        onAddressTap: () async {
          await context.router.push(const AddressSelectionRoute());
          if (mounted) _loadSavedAddress();
        },
        onProfileTap: () async {
          final scope = ProfileNavigationScope.maybeOf(context);
          final tabsRouter = AutoTabsRouter.of(context);
          final canGoToProfile = await scope?.navigateToProfileOrRequireAuth() ?? false;
          if (canGoToProfile && mounted) {
            tabsRouter.setActiveIndex(3);
          }
        },
      ),
      body: SafeArea(
        child: BlocConsumer<PopularCubit, PopularState>(
          listener: (context, state) {
            if (state is PopularError) {
              context.showSnack(state.message, isError: true);
            } else if (state is PopularLoaded) {
              setState(() {
                menu = state.products;
              });
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _initializeData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    const ActiveOrdersBannerWidget(),
                    const BonusCardWidget(),
                    RowTextWidget(text: context.l10n.popularFood, theme: Theme.of(context)),
                    if (menu.isNotEmpty) PopularFoodSectionWidget(menu: menu),
                    // RowTextWidget(text: 'Анонсы', theme: Theme.of(context)),
                    // NewsWidgets(
                    //   subtitle: context.l10n.news,
                    //   title: 'Дияр',
                    //   image: 'assets/images/news_da.png',
                    //   onTap: () => context.router.push(const NewsRoute()),
                    // ),
                    // RowTextWidget(text: 'Инфоцентр', theme: Theme.of(context)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
