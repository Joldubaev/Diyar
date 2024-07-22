// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i34;
import 'package:diyar/features/about_us/presentation/pages/about/about_us_page.dart'
    as _i1;
import 'package:diyar/features/about_us/presentation/pages/about/coffe_page.dart'
    as _i4;
import 'package:diyar/features/about_us/presentation/pages/about/hall_page.dart'
    as _i8;
import 'package:diyar/features/about_us/presentation/pages/about/restoran_page.dart'
    as _i21;
import 'package:diyar/features/about_us/presentation/pages/about/vip_page.dart'
    as _i33;
import 'package:diyar/features/about_us/presentation/pages/contact/contact_page.dart'
    as _i5;
import 'package:diyar/features/auth/data/models/user_model.dart' as _i39;
import 'package:diyar/features/auth/presentation/pages/sign_in/sign_in_page.dart'
    as _i24;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_otp_page.dart'
    as _i25;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_page.dart'
    as _i26;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_succes.dart'
    as _i27;
import 'package:diyar/features/auth/presentation/pages/splash/splash_page.dart'
    as _i28;
import 'package:diyar/features/auth/presentation/widgets/reset_password.dart'
    as _i20;
import 'package:diyar/features/cart/cart.dart' as _i36;
import 'package:diyar/features/cart/data/models/cart_item_model.dart' as _i38;
import 'package:diyar/features/cart/presentation/pages/cart_page.dart' as _i3;
import 'package:diyar/features/curier/presentation/pages/curier_page.dart'
    as _i6;
import 'package:diyar/features/curier/presentation/pages/history_page.dart'
    as _i9;
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart'
    as _i41;
import 'package:diyar/features/history/presentation/pages/order_active/order_active_page.dart'
    as _i2;
import 'package:diyar/features/history/presentation/pages/order_active/order_detail_page.dart'
    as _i14;
import 'package:diyar/features/history/presentation/pages/order_history/user_order_history.dart'
    as _i30;
import 'package:diyar/features/history/presentation/pages/order_history_page.dart'
    as _i15;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_detail_page.dart'
    as _i31;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_history_page.dart'
    as _i32;
import 'package:diyar/features/map/presentation/user_map/order_map.dart'
    as _i16;
import 'package:diyar/features/menu/presentation/pages/menu_page.dart' as _i12;
import 'package:diyar/features/menu/presentation/pages/search_menu_page.dart'
    as _i23;
import 'package:diyar/features/order/presentation/pages/delivery_page.dart'
    as _i7;
import 'package:diyar/features/order/presentation/pages/pickup_page.dart'
    as _i17;
import 'package:diyar/features/profile/presentation/pages/profile/profile_page.dart'
    as _i19;
import 'package:diyar/features/profile/presentation/pages/profile_info/profile_info_page.dart'
    as _i18;
import 'package:diyar/features/sale_news/data/model/sale_model.dart' as _i40;
import 'package:diyar/features/sale_news/presentation/pages/news/news_page.dart'
    as _i13;
import 'package:diyar/features/sale_news/presentation/pages/sale/sale_page.dart'
    as _i22;
import 'package:diyar/features/templates/presentation/pages/templates_page.dart'
    as _i29;
import 'package:diyar/shared/pages/main_home/home_page.dart' as _i10;
import 'package:diyar/shared/pages/main_home/main_page.dart' as _i11;
import 'package:flutter/cupertino.dart' as _i37;
import 'package:flutter/material.dart' as _i35;

abstract class $AppRouter extends _i34.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i34.PageFactory> pagesMap = {
    AboutUsRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AboutUsPage(),
      );
    },
    ActiveOrderRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ActiveOrderPage(),
      );
    },
    CartRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CartPage(),
      );
    },
    CofeRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.CofePage(),
      );
    },
    ContactRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ContactPage(),
      );
    },
    CurierRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.CurierPage(),
      );
    },
    DeliveryFormRoute.name: (routeData) {
      final args = routeData.argsAs<DeliveryFormRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.DeliveryFormPage(
          key: args.key,
          cart: args.cart,
          dishCount: args.dishCount,
          totalPrice: args.totalPrice,
        ),
      );
    },
    HallRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.HallPage(),
      );
    },
    HistoryRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.HistoryPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.HomePage(),
      );
    },
    MainRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.MainPage(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.MenuPage(),
      );
    },
    NewsRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.NewsPage(),
      );
    },
    OrderDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.OrderDetailPage(
          key: args.key,
          orderNumber: args.orderNumber,
        ),
      );
    },
    OrderHistoryRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.OrderHistoryPage(),
      );
    },
    OrderMapRoute.name: (routeData) {
      final args = routeData.argsAs<OrderMapRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.OrderMapPage(
          key: args.key,
          cart: args.cart,
          totalPrice: args.totalPrice,
        ),
      );
    },
    PickupFormRoute.name: (routeData) {
      final args = routeData.argsAs<PickupFormRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.PickupFormPage(
          key: args.key,
          cart: args.cart,
          totalPrice: args.totalPrice,
        ),
      );
    },
    ProfileInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileInfoRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.ProfileInfoPage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.ProfilePage(),
      );
    },
    RessetPasswordRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.RessetPasswordPage(),
      );
    },
    RestorantRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.RestorantPage(),
      );
    },
    SaleRoute.name: (routeData) {
      final args =
          routeData.argsAs<SaleRouteArgs>(orElse: () => const SaleRouteArgs());
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i22.SalePage(
          key: args.key,
          sale: args.sale,
        ),
      );
    },
    SearchMenuRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.SearchMenuPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.SignInPage(),
      );
    },
    SignUpOtpRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpOtpRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i25.SignUpOtpPage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.SignUpPage(),
      );
    },
    SignUpSucces.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i27.SignUpSucces(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i28.SplashScreen(),
      );
    },
    TemplatesRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i29.TemplatesPage(),
      );
    },
    UserOrderHistoryRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i30.UserOrderHistoryPage(),
      );
    },
    UserPickupDetailRoute.name: (routeData) {
      final args = routeData.argsAs<UserPickupDetailRouteArgs>();
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i31.UserPickupDetailPage(
          key: args.key,
          order: args.order,
        ),
      );
    },
    UserPickupHistoryRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i32.UserPickupHistoryPage(),
      );
    },
    VipRoute.name: (routeData) {
      return _i34.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i33.VipPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsRoute extends _i34.PageRouteInfo<void> {
  const AboutUsRoute({List<_i34.PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ActiveOrderPage]
class ActiveOrderRoute extends _i34.PageRouteInfo<void> {
  const ActiveOrderRoute({List<_i34.PageRouteInfo>? children})
      : super(
          ActiveOrderRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActiveOrderRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CartPage]
class CartRoute extends _i34.PageRouteInfo<void> {
  const CartRoute({List<_i34.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CofePage]
class CofeRoute extends _i34.PageRouteInfo<void> {
  const CofeRoute({List<_i34.PageRouteInfo>? children})
      : super(
          CofeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CofeRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ContactPage]
class ContactRoute extends _i34.PageRouteInfo<void> {
  const ContactRoute({List<_i34.PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i6.CurierPage]
class CurierRoute extends _i34.PageRouteInfo<void> {
  const CurierRoute({List<_i34.PageRouteInfo>? children})
      : super(
          CurierRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurierRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i7.DeliveryFormPage]
class DeliveryFormRoute extends _i34.PageRouteInfo<DeliveryFormRouteArgs> {
  DeliveryFormRoute({
    _i35.Key? key,
    required List<_i36.CartItemModel> cart,
    required int dishCount,
    required int totalPrice,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          DeliveryFormRoute.name,
          args: DeliveryFormRouteArgs(
            key: key,
            cart: cart,
            dishCount: dishCount,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryFormRoute';

  static const _i34.PageInfo<DeliveryFormRouteArgs> page =
      _i34.PageInfo<DeliveryFormRouteArgs>(name);
}

class DeliveryFormRouteArgs {
  const DeliveryFormRouteArgs({
    this.key,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
  });

  final _i35.Key? key;

  final List<_i36.CartItemModel> cart;

  final int dishCount;

  final int totalPrice;

  @override
  String toString() {
    return 'DeliveryFormRouteArgs{key: $key, cart: $cart, dishCount: $dishCount, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i8.HallPage]
class HallRoute extends _i34.PageRouteInfo<void> {
  const HallRoute({List<_i34.PageRouteInfo>? children})
      : super(
          HallRoute.name,
          initialChildren: children,
        );

  static const String name = 'HallRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i9.HistoryPage]
class HistoryRoute extends _i34.PageRouteInfo<void> {
  const HistoryRoute({List<_i34.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i10.HomePage]
class HomeRoute extends _i34.PageRouteInfo<void> {
  const HomeRoute({List<_i34.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i11.MainPage]
class MainRoute extends _i34.PageRouteInfo<void> {
  const MainRoute({List<_i34.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i12.MenuPage]
class MenuRoute extends _i34.PageRouteInfo<void> {
  const MenuRoute({List<_i34.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i13.NewsPage]
class NewsRoute extends _i34.PageRouteInfo<void> {
  const NewsRoute({List<_i34.PageRouteInfo>? children})
      : super(
          NewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i14.OrderDetailPage]
class OrderDetailRoute extends _i34.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i35.Key? key,
    required String orderNumber,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(
            key: key,
            orderNumber: orderNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static const _i34.PageInfo<OrderDetailRouteArgs> page =
      _i34.PageInfo<OrderDetailRouteArgs>(name);
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({
    this.key,
    required this.orderNumber,
  });

  final _i35.Key? key;

  final String orderNumber;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderNumber: $orderNumber}';
  }
}

/// generated route for
/// [_i15.OrderHistoryPage]
class OrderHistoryRoute extends _i34.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i34.PageRouteInfo>? children})
      : super(
          OrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderHistoryRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i16.OrderMapPage]
class OrderMapRoute extends _i34.PageRouteInfo<OrderMapRouteArgs> {
  OrderMapRoute({
    _i35.Key? key,
    required List<_i36.CartItemModel> cart,
    required int totalPrice,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          OrderMapRoute.name,
          args: OrderMapRouteArgs(
            key: key,
            cart: cart,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderMapRoute';

  static const _i34.PageInfo<OrderMapRouteArgs> page =
      _i34.PageInfo<OrderMapRouteArgs>(name);
}

class OrderMapRouteArgs {
  const OrderMapRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
  });

  final _i35.Key? key;

  final List<_i36.CartItemModel> cart;

  final int totalPrice;

  @override
  String toString() {
    return 'OrderMapRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i17.PickupFormPage]
class PickupFormRoute extends _i34.PageRouteInfo<PickupFormRouteArgs> {
  PickupFormRoute({
    _i37.Key? key,
    required List<_i38.CartItemModel> cart,
    required int totalPrice,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          PickupFormRoute.name,
          args: PickupFormRouteArgs(
            key: key,
            cart: cart,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'PickupFormRoute';

  static const _i34.PageInfo<PickupFormRouteArgs> page =
      _i34.PageInfo<PickupFormRouteArgs>(name);
}

class PickupFormRouteArgs {
  const PickupFormRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
  });

  final _i37.Key? key;

  final List<_i38.CartItemModel> cart;

  final int totalPrice;

  @override
  String toString() {
    return 'PickupFormRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i18.ProfileInfoPage]
class ProfileInfoRoute extends _i34.PageRouteInfo<ProfileInfoRouteArgs> {
  ProfileInfoRoute({
    _i35.Key? key,
    required _i39.UserModel user,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          ProfileInfoRoute.name,
          args: ProfileInfoRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileInfoRoute';

  static const _i34.PageInfo<ProfileInfoRouteArgs> page =
      _i34.PageInfo<ProfileInfoRouteArgs>(name);
}

class ProfileInfoRouteArgs {
  const ProfileInfoRouteArgs({
    this.key,
    required this.user,
  });

  final _i35.Key? key;

  final _i39.UserModel user;

  @override
  String toString() {
    return 'ProfileInfoRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i19.ProfilePage]
class ProfileRoute extends _i34.PageRouteInfo<void> {
  const ProfileRoute({List<_i34.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i20.RessetPasswordPage]
class RessetPasswordRoute extends _i34.PageRouteInfo<void> {
  const RessetPasswordRoute({List<_i34.PageRouteInfo>? children})
      : super(
          RessetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'RessetPasswordRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i21.RestorantPage]
class RestorantRoute extends _i34.PageRouteInfo<void> {
  const RestorantRoute({List<_i34.PageRouteInfo>? children})
      : super(
          RestorantRoute.name,
          initialChildren: children,
        );

  static const String name = 'RestorantRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i22.SalePage]
class SaleRoute extends _i34.PageRouteInfo<SaleRouteArgs> {
  SaleRoute({
    _i35.Key? key,
    _i40.SaleModel? sale,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          SaleRoute.name,
          args: SaleRouteArgs(
            key: key,
            sale: sale,
          ),
          initialChildren: children,
        );

  static const String name = 'SaleRoute';

  static const _i34.PageInfo<SaleRouteArgs> page =
      _i34.PageInfo<SaleRouteArgs>(name);
}

class SaleRouteArgs {
  const SaleRouteArgs({
    this.key,
    this.sale,
  });

  final _i35.Key? key;

  final _i40.SaleModel? sale;

  @override
  String toString() {
    return 'SaleRouteArgs{key: $key, sale: $sale}';
  }
}

/// generated route for
/// [_i23.SearchMenuPage]
class SearchMenuRoute extends _i34.PageRouteInfo<void> {
  const SearchMenuRoute({List<_i34.PageRouteInfo>? children})
      : super(
          SearchMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchMenuRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i24.SignInPage]
class SignInRoute extends _i34.PageRouteInfo<void> {
  const SignInRoute({List<_i34.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i25.SignUpOtpPage]
class SignUpOtpRoute extends _i34.PageRouteInfo<SignUpOtpRouteArgs> {
  SignUpOtpRoute({
    _i35.Key? key,
    required _i39.UserModel user,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          SignUpOtpRoute.name,
          args: SignUpOtpRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpOtpRoute';

  static const _i34.PageInfo<SignUpOtpRouteArgs> page =
      _i34.PageInfo<SignUpOtpRouteArgs>(name);
}

class SignUpOtpRouteArgs {
  const SignUpOtpRouteArgs({
    this.key,
    required this.user,
  });

  final _i35.Key? key;

  final _i39.UserModel user;

  @override
  String toString() {
    return 'SignUpOtpRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i26.SignUpPage]
class SignUpRoute extends _i34.PageRouteInfo<void> {
  const SignUpRoute({List<_i34.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i27.SignUpSucces]
class SignUpSucces extends _i34.PageRouteInfo<void> {
  const SignUpSucces({List<_i34.PageRouteInfo>? children})
      : super(
          SignUpSucces.name,
          initialChildren: children,
        );

  static const String name = 'SignUpSucces';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i28.SplashScreen]
class SplashRoute extends _i34.PageRouteInfo<void> {
  const SplashRoute({List<_i34.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i29.TemplatesPage]
class TemplatesRoute extends _i34.PageRouteInfo<void> {
  const TemplatesRoute({List<_i34.PageRouteInfo>? children})
      : super(
          TemplatesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TemplatesRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i30.UserOrderHistoryPage]
class UserOrderHistoryRoute extends _i34.PageRouteInfo<void> {
  const UserOrderHistoryRoute({List<_i34.PageRouteInfo>? children})
      : super(
          UserOrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserOrderHistoryRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i31.UserPickupDetailPage]
class UserPickupDetailRoute
    extends _i34.PageRouteInfo<UserPickupDetailRouteArgs> {
  UserPickupDetailRoute({
    _i35.Key? key,
    required _i41.UserPickupHistoryModel order,
    List<_i34.PageRouteInfo>? children,
  }) : super(
          UserPickupDetailRoute.name,
          args: UserPickupDetailRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'UserPickupDetailRoute';

  static const _i34.PageInfo<UserPickupDetailRouteArgs> page =
      _i34.PageInfo<UserPickupDetailRouteArgs>(name);
}

class UserPickupDetailRouteArgs {
  const UserPickupDetailRouteArgs({
    this.key,
    required this.order,
  });

  final _i35.Key? key;

  final _i41.UserPickupHistoryModel order;

  @override
  String toString() {
    return 'UserPickupDetailRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i32.UserPickupHistoryPage]
class UserPickupHistoryRoute extends _i34.PageRouteInfo<void> {
  const UserPickupHistoryRoute({List<_i34.PageRouteInfo>? children})
      : super(
          UserPickupHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserPickupHistoryRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}

/// generated route for
/// [_i33.VipPage]
class VipRoute extends _i34.PageRouteInfo<void> {
  const VipRoute({List<_i34.PageRouteInfo>? children})
      : super(
          VipRoute.name,
          initialChildren: children,
        );

  static const String name = 'VipRoute';

  static const _i34.PageInfo<void> page = _i34.PageInfo<void>(name);
}
