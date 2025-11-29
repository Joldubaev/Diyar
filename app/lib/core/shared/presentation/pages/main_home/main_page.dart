import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    final theme = Theme.of(context);
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        MenuRoute(),
        OrderHistoryRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          floatingActionButton: _buildFloatingActionButton(context, theme),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) async {
              final restrictedTabs = [2, 3];
              bool allowNavigation = true;
              if (restrictedTabs.contains(index) && !UserHelper.isAuth()) {
                await _showRegisterDialog(context);
                if (!UserHelper.isAuth()) {
                  allowNavigation = false;
                }
              }
              if (allowNavigation) {
                tabsRouter.setActiveIndex(index);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ThemeData theme) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int cartCount = 0;
        if (state is CartLoaded) {
          cartCount = state.totalItems;
        }
        return Stack(
          children: [
            FloatingActionButton(
              onPressed: () async {
                if (!UserHelper.isAuth()) {
                  await _showRegisterDialog(context);
                  if (UserHelper.isAuth() && context.mounted) {
                    context.router.push(const CartRoute());
                  }
                } else {
                  context.router.push(const CartRoute());
                }
              },
              tooltip: context.l10n.cart,
              child: SvgPicture.asset(
                "assets/icons/cart_icon.svg",
                height: 40,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onTertiaryFixed,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: _buildBadge(theme, cartCount),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBadge(ThemeData theme, int cartCount) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        "${cartCount > 99 ? "99+" : cartCount}",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.red,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showRegisterDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationAlertDialog(
          onRegister: () async {
            await context.router.pushAndPopUntil(
              CheckPhoneNumberRoute(),
              predicate: (route) => false,
            );
          },
          onLogin: () {
            context.router.pushAndPopUntil(
              const SignInRoute(),
              predicate: (route) => false,
            );
          },
        );
      },
    );
  }
}
