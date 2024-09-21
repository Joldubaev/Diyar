import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/core/utils/helper/user_helper.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/shared/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
          floatingActionButton: StreamBuilder<List<CartItemModel>>(
            stream: cartItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cart = snapshot.data!;
              }
              final cartCount = (cart.isNotEmpty
                  ? cart
                      .map((e) => e.quantity)
                      .reduce((vl, el) => (vl ?? 0) + (el ?? 0))
                  : 0);
              return SizedBox(
                child: Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        context.router.push(const CartRoute());
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
                        child: Badge(
                          largeSize: 20,
                          label: Text(
                            "${(cartCount ?? 0) > 99 ? "99+" : cartCount}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onTertiary,
                              height: 1,
                            ),
                          ),
                          isLabelVisible: cart.isNotEmpty,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              if (index == 3 && !UserHelper.isAuth()) {
                context.pushRoute(const SignInRoute());
                return;
              }
              tabsRouter.setActiveIndex(index);
              setState(() {
                currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}

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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            offset: const Offset(0, -1),
            blurRadius: 20.0,
            spreadRadius: .5,
          ),
        ],
      ),
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavIcon(
                iconPath: "assets/icons/home_icon.svg",
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              NavIcon(
                iconPath: "assets/icons/menu_icon.svg",
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              NavIcon(
                iconPath: "assets/icons/orders_icon.svg",
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              NavIcon(
                iconPath: "assets/icons/profile_icon.svg",
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
