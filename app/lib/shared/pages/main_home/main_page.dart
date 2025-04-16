import 'package:auto_route/auto_route.dart';
import '../../../core/components/custom_dialog/custom_dialog.dart';
import '../../../core/router/routes.gr.dart';
import '../../../core/utils/helper/user_helper.dart';
import '../../../features/app/cubit/remote_config_cubit.dart';
import '../../../features/cart/cart.dart';
import '../../../core/theme/app_colors.dart';
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
  int currentIndex = 0;
  bool isLoading = false;
  String? token;
  List<CartItemModel> cart = [];
  late Stream<List<CartItemModel>> cartItems;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCartItems();
    cartItems = context.read<CartCubit>().cart;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<RemoteConfigCubit>().init();
    });
  }

  // Check authentication and handle tab changes
  void _onTabTapped(int index) async {
    if (index == 3 && !UserHelper.isAuth()) {
      // If the user tries to access Profile (index 3), show registration dialog if not authenticated
      await _showRegisterDialog(context);
      if (!UserHelper.isAuth()) {
        // User is still not authenticated, prevent accessing Profile
        return;
      }
    }
    // If the user is authenticated or it's not the Profile tab, update the current index
    setState(() {
      currentIndex = index;
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
            onTap: (index) {
              _onTabTapped(index);
              // Set active tab index only if the user is authenticated or trying to access non-restricted tabs
              if (index != 3 || UserHelper.isAuth()) {
                tabsRouter.setActiveIndex(index);
              }
            },
          ),
        );
      },
    );
  }

  // Build Floating Action Button for the cart with authentication check
  Widget _buildFloatingActionButton(BuildContext context, ThemeData theme) {
    return StreamBuilder<List<CartItemModel>>(
      stream: cartItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          cart = snapshot.data!;
        }
        final cartCount =
            cart.fold(0, (sum, item) => sum + (item.quantity ?? 0));

        return Stack(
          children: [
            FloatingActionButton(
              onPressed: () {
                // Check if the user is authenticated before opening the cart
                if (!UserHelper.isAuth()) {
                  _showRegisterDialog(context);
                } else {
                  context.router.push(const CartRoute());
                }
              },
              child: SvgPicture.asset(
                "assets/icons/cart_icon.svg",
                height: 40,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onTertiaryFixed,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (cart.isNotEmpty)
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

  // Helper method to build badge for cart item count
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

  // Dialog to show registration prompt if user is not authenticated
  Future<void> _showRegisterDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationAlertDialog(
          onRegister: () async {
            await context.router.push(const SignInRoute());
          },
          onCancel: () {
            context.router.pushAndPopUntil(
              const MainRoute(),
              predicate: (route) => false,
            );
          },
        );
      },
    );
  }
}

// Custom Bottom Navigation Bar with selected and unselected states
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unselectedColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.8)
        : Colors.grey;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: theme.colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: unselectedColor,
      items: [
        _buildBottomNavItem(context, "assets/icons/home_icon.svg", "Главная"),
        _buildBottomNavItem(context, "assets/icons/menu_icon.svg", "Меню"),
        _buildBottomNavItem(context, "assets/icons/orders_icon.svg", "История"),
        _buildBottomNavItem(
            context, "assets/icons/profile_icon.svg", "Профиль"),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    BuildContext context,
    String iconPath,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
