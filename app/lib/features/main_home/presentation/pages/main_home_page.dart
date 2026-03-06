import 'package:auto_route/auto_route.dart';
import 'package:diyar/common/common.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/di/injectable_config.dart' as di;
import 'package:diyar/features/active_order/active_order.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/features/home_content/presentation/cubit/home_content_cubit.dart';
import 'package:diyar/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:diyar/features/menu/presentation/cubit/popular_cubit.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<MenuBloc>()..add(GetFoodsByCategoryEvent())),
        BlocProvider(create: (_) => di.sl<PopularCubit>()),
        BlocProvider(create: (_) => di.sl<HomeContentCubit>()),
        BlocProvider(create: (_) => di.sl<ActiveOrderCubit>()),
        BlocProvider(create: (_) => di.sl<SignInCubit>()),
      ],
      child: AutoTabsRouter(
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
      ),
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
