import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_about_us_banner.dart';
import '../widgets/home_active_orders_section.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_bonus_card_section.dart';
import '../widgets/home_popular_food_section.dart';
import '../widgets/home_stories_section.dart';
import 'profile_navigation_scope.dart';

@RoutePage()
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with WidgetsBindingObserver {
  String? _savedAddress;
  bool _addressDialogShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAddressConfirmation();
      _loadHome();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAddressConfirmation();
    }
  }

  Future<void> _loadHome() async {
    if (!mounted) return;
    final isAuth = UserHelper.isAuth();
    if (isAuth) {
      context.read<ProfileCubit>().getUser();
    }
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
    if (_addressDialogShowing || !mounted) return;
    _addressDialogShowing = true;
    await AddressConfirmationHandler.checkAndShow(
      context,
      onAddressChanged: _loadSavedAddress,
    );
    _addressDialogShowing = false;
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
                const HomeStoriesSection(),
                const HomeActiveOrdersSection(),
                const HomeBonusCardSection(),
                const SizedBox(height: 20),
                const HomeAboutUsBanner(),
                const SizedBox(height: 20),
                const HomePopularFoodSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
