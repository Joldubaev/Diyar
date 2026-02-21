import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_navigation_scope.dart';
import '../widgets/cart_fab_widget.dart';

@RoutePage()
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<RemoteConfigCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeTabRoute(),
        MenuRoute(),
        OrderHistoryRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return ProfileNavigationScope(
          navigateToProfileOrRequireAuth: () => _navigateToProfileOrRequireAuth(context),
          child: Scaffold(
            extendBody: true,
            body: child,
            floatingActionButton: CartFabWidget(showRegisterDialog: showRegistrationAlertDialog),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) async {
                final restrictedTabs = [2, 3];
                bool allowNavigation = true;
                if (restrictedTabs.contains(index)) {
                  allowNavigation = await _navigateToProfileOrRequireAuth(context);
                }
                if (allowNavigation) {
                  tabsRouter.setActiveIndex(index);
                }
              },
            ),
          ),
        );
      },
    );
  }

  /// Единая точка: «перейти в профиль или потребовать авторизацию».
  /// Возвращает true, если пользователь авторизован (можно переключать на таб профиля).
  Future<bool> _navigateToProfileOrRequireAuth(BuildContext context) async {
    if (UserHelper.isAuth()) return true;
    await showRegistrationAlertDialog(context);
    return UserHelper.isAuth();
  }
}
