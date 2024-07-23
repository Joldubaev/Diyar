import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool isLoading = false;
  String? token;
  List<CartItemModel> cart = [];
  late Stream<List<CartItemModel>> cartItems;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCartItems();
    cartItems = context.read<CartCubit>().cart;
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: false,
      barrierDismissible: false,
      shouldPopScope: () => true,
      onUpdate: () {
        if (Platform.isIOS) {
          // TODO: Add link to the app app store
          launchUrl(
              Uri.parse("https://apps.apple.com/ru/app/diyar/id1581440734"));
        } else {
          // TODO: Add link to the app google play
          launchUrl(Uri.parse(
              "https://play.google.com/store/apps/details?id=com.diyar.app"));
        }
        return true;
      },
      child: AutoTabsRouter(
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
                              Theme.of(context).colorScheme.onTertiaryFixed,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                      height: 1,
                                    ),
                              ),
                              isLabelVisible: cart.isNotEmpty,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: SizedBox(
              height: 100,
              child: BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                elevation: 45,
                enableFeedback: false,
                onTap: (value) {
                  tabsRouter.setActiveIndex(value);
                  setState(() {
                    _currentIndex = value;
                    tabsRouter.setActiveIndex(value);
                  });
                },
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                unselectedItemColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                useLegacyColorScheme: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset(
                        "assets/icons/home_icon.svg",
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: context.l10n.main,
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset(
                        "assets/icons/menu_icon.svg",
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 1
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: context.l10n.menu,
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset(
                        "assets/icons/orders_icon.svg",
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 2
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: 'Заказы',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: SvgPicture.asset(
                        "assets/icons/profile_icon.svg",
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 3
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: context.l10n.profile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
