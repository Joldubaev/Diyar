import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/cart/data/models/cart_item_model.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        MenuRoute(),
        OrderHistoryRoute(),
        CartRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
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
              selectedItemColor: AppColors.primary,
              backgroundColor: Colors.white,
              unselectedItemColor: AppColors.grey,
              useLegacyColorScheme: false,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/home_icon.svg",
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 0
                            ? AppColors.primary
                            : AppColors.black1,
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
                            ? AppColors.primary
                            : AppColors.black1,
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
                            ? AppColors.primary
                            : AppColors.black1,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: 'Мои Заказы',
                ),
                BottomNavigationBarItem(
                  icon: StreamBuilder<List<CartItemModel>>(
                      stream: cartItems,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          cart = snapshot.data ?? [];
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Badge(
                            label: Text(
                                "${cart.isNotEmpty ? cart.map((e) => e.quantity).reduce((vl, el) => (vl ?? 0) + (el ?? 0)) : 0}"),
                            isLabelVisible: cart.isNotEmpty,
                            child: SvgPicture.asset(
                              "assets/icons/cart_icon.svg",
                              colorFilter: ColorFilter.mode(
                                _currentIndex == 3
                                    ? AppColors.primary
                                    : AppColors.black1,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        );
                      }),
                  label: context.l10n.cart,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/profile_icon.svg",
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 4
                            ? AppColors.primary
                            : AppColors.black1,
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
    );
  }
}
