// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i30;
import 'package:diyar/features/about_us/presentation/pages/about/about_us_page.dart'
    as _i1;
import 'package:diyar/features/about_us/presentation/pages/about/coffe_page.dart'
    as _i3;
import 'package:diyar/features/about_us/presentation/pages/about/hall_page.dart'
    as _i9;
import 'package:diyar/features/about_us/presentation/pages/about/restoran_page.dart'
    as _i22;
import 'package:diyar/features/about_us/presentation/pages/about/vip_page.dart'
    as _i29;
import 'package:diyar/features/about_us/presentation/pages/contact/contact_page.dart'
    as _i4;
import 'package:diyar/features/auth/data/models/user_mpdel.dart' as _i33;
import 'package:diyar/features/auth/presentation/pages/sign_in/sign_in_page.dart'
    as _i25;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_page.dart'
    as _i26;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_succes.dart'
    as _i27;
import 'package:diyar/features/auth/presentation/pages/splash/splash_page.dart'
    as _i28;
import 'package:diyar/features/auth/presentation/widgets/reset_password.dart'
    as _i21;
import 'package:diyar/features/cart/data/models/models.dart' as _i32;
import 'package:diyar/features/cart/presentation/pages/cart_page.dart' as _i2;
import 'package:diyar/features/curier/presentation/pages/curier_page.dart'
    as _i6;
import 'package:diyar/features/curier/presentation/pages/curier_profile_page.dart'
    as _i7;
import 'package:diyar/features/curier/presentation/pages/history_page.dart'
    as _i10;
import 'package:diyar/features/history/presentation/pages/order_active/order_detail_page.dart'
    as _i15;
import 'package:diyar/features/history/presentation/pages/order_history_page.dart'
    as _i16;
import 'package:diyar/features/home_features/data/model/sale_model.dart'
    as _i34;
import 'package:diyar/features/home_features/presentation/pages/news/news_page.dart'
    as _i14;
import 'package:diyar/features/home_features/presentation/pages/sale/sale_page.dart'
    as _i23;
import 'package:diyar/features/map/presentation/user_map/order_map.dart'
    as _i17;
import 'package:diyar/features/menu/presentation/pages/menu_page.dart' as _i13;
import 'package:diyar/features/menu/presentation/pages/search_menu_page.dart'
    as _i24;
import 'package:diyar/features/order/presentation/pages/create_order/create_order_page.dart'
    as _i5;
import 'package:diyar/features/order/presentation/pages/create_order/delivery_order.dart'
    as _i8;
import 'package:diyar/features/order/presentation/pages/create_order/order_success.dart'
    as _i18;
import 'package:diyar/features/profile/presentation/pages/profile/profile_page.dart'
    as _i20;
import 'package:diyar/features/profile/presentation/pages/profile_info/profile_info_page.dart'
    as _i19;
import 'package:diyar/shared/pages/main_home/home_page.dart' as _i11;
import 'package:diyar/shared/pages/main_home/main_page.dart' as _i12;
import 'package:flutter/material.dart' as _i31;

abstract class $AppRouter extends _i30.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i30.PageFactory> pagesMap = {
    AboutUsRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AboutUsPage(),
      );
    },
    CartRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.CartPage(),
      );
    },
    CofeRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CofePage(),
      );
    },
    ContactRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ContactPage(),
      );
    },
    CreateOrderRoute.name: (routeData) {
      final args = routeData.argsAs<CreateOrderRouteArgs>();
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.CreateOrderPage(
          key: args.key,
          cart: args.cart,
          dishCount: args.dishCount,
        ),
      );
    },
    CurierRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.CurierPage(),
      );
    },
    CurierPrpfileRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.CurierPrpfilePage(),
      );
    },
    DeliveryFormRoute.name: (routeData) {
      final args = routeData.argsAs<DeliveryFormRouteArgs>();
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.DeliveryFormPage(
          key: args.key,
          cart: args.cart,
          user: args.user,
        ),
      );
    },
    HallRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.HallPage(),
      );
    },
    HistoryRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.HistoryPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.HomePage(),
      );
    },
    MainRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.MainPage(),
      );
    },
    MenuRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.MenuPage(),
      );
    },
    NewsRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.NewsPage(),
      );
    },
    OrderDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailRouteArgs>();
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.OrderDetailPage(
          key: args.key,
          orderNumber: args.orderNumber,
        ),
      );
    },
    OrderHistoryRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.OrderHistoryPage(),
      );
    },
    OrderMapRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.OrderMapPage(),
      );
    },
    OrderSuccess.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.OrderSuccess(),
      );
    },
    ProfileInfoRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileInfoRouteArgs>();
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.ProfileInfoPage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.ProfilePage(),
      );
    },
    RessetPasswordRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.RessetPasswordPage(),
      );
    },
    RestorantRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.RestorantPage(),
      );
    },
    SaleRoute.name: (routeData) {
      final args =
          routeData.argsAs<SaleRouteArgs>(orElse: () => const SaleRouteArgs());
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i23.SalePage(
          key: args.key,
          sale: args.sale,
        ),
      );
    },
    SearchMenuRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.SearchMenuPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.SignInPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.SignUpPage(),
      );
    },
    SignUpSucces.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i27.SignUpSucces(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i28.SplashScreen(),
      );
    },
    VipRoute.name: (routeData) {
      return _i30.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i29.VipPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsRoute extends _i30.PageRouteInfo<void> {
  const AboutUsRoute({List<_i30.PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i2.CartPage]
class CartRoute extends _i30.PageRouteInfo<void> {
  const CartRoute({List<_i30.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CofePage]
class CofeRoute extends _i30.PageRouteInfo<void> {
  const CofeRoute({List<_i30.PageRouteInfo>? children})
      : super(
          CofeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CofeRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ContactPage]
class ContactRoute extends _i30.PageRouteInfo<void> {
  const ContactRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i5.CreateOrderPage]
class CreateOrderRoute extends _i30.PageRouteInfo<CreateOrderRouteArgs> {
  CreateOrderRoute({
    _i31.Key? key,
    required List<_i32.CartItemModel> cart,
    required int dishCount,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          CreateOrderRoute.name,
          args: CreateOrderRouteArgs(
            key: key,
            cart: cart,
            dishCount: dishCount,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateOrderRoute';

  static const _i30.PageInfo<CreateOrderRouteArgs> page =
      _i30.PageInfo<CreateOrderRouteArgs>(name);
}

class CreateOrderRouteArgs {
  const CreateOrderRouteArgs({
    this.key,
    required this.cart,
    required this.dishCount,
  });

  final _i31.Key? key;

  final List<_i32.CartItemModel> cart;

  final int dishCount;

  @override
  String toString() {
    return 'CreateOrderRouteArgs{key: $key, cart: $cart, dishCount: $dishCount}';
  }
}

/// generated route for
/// [_i6.CurierPage]
class CurierRoute extends _i30.PageRouteInfo<void> {
  const CurierRoute({List<_i30.PageRouteInfo>? children})
      : super(
          CurierRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurierRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i7.CurierPrpfilePage]
class CurierPrpfileRoute extends _i30.PageRouteInfo<void> {
  const CurierPrpfileRoute({List<_i30.PageRouteInfo>? children})
      : super(
          CurierPrpfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurierPrpfileRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i8.DeliveryFormPage]
class DeliveryFormRoute extends _i30.PageRouteInfo<DeliveryFormRouteArgs> {
  DeliveryFormRoute({
    _i31.Key? key,
    required List<_i32.CartItemModel> cart,
    _i33.UserModel? user,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          DeliveryFormRoute.name,
          args: DeliveryFormRouteArgs(
            key: key,
            cart: cart,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryFormRoute';

  static const _i30.PageInfo<DeliveryFormRouteArgs> page =
      _i30.PageInfo<DeliveryFormRouteArgs>(name);
}

class DeliveryFormRouteArgs {
  const DeliveryFormRouteArgs({
    this.key,
    required this.cart,
    this.user,
  });

  final _i31.Key? key;

  final List<_i32.CartItemModel> cart;

  final _i33.UserModel? user;

  @override
  String toString() {
    return 'DeliveryFormRouteArgs{key: $key, cart: $cart, user: $user}';
  }
}

/// generated route for
/// [_i9.HallPage]
class HallRoute extends _i30.PageRouteInfo<void> {
  const HallRoute({List<_i30.PageRouteInfo>? children})
      : super(
          HallRoute.name,
          initialChildren: children,
        );

  static const String name = 'HallRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i10.HistoryPage]
class HistoryRoute extends _i30.PageRouteInfo<void> {
  const HistoryRoute({List<_i30.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i30.PageRouteInfo<void> {
  const HomeRoute({List<_i30.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i12.MainPage]
class MainRoute extends _i30.PageRouteInfo<void> {
  const MainRoute({List<_i30.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i13.MenuPage]
class MenuRoute extends _i30.PageRouteInfo<void> {
  const MenuRoute({List<_i30.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i14.NewsPage]
class NewsRoute extends _i30.PageRouteInfo<void> {
  const NewsRoute({List<_i30.PageRouteInfo>? children})
      : super(
          NewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i15.OrderDetailPage]
class OrderDetailRoute extends _i30.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i31.Key? key,
    required String orderNumber,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(
            key: key,
            orderNumber: orderNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static const _i30.PageInfo<OrderDetailRouteArgs> page =
      _i30.PageInfo<OrderDetailRouteArgs>(name);
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({
    this.key,
    required this.orderNumber,
  });

  final _i31.Key? key;

  final String orderNumber;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderNumber: $orderNumber}';
  }
}

/// generated route for
/// [_i16.OrderHistoryPage]
class OrderHistoryRoute extends _i30.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i30.PageRouteInfo>? children})
      : super(
          OrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderHistoryRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i17.OrderMapPage]
class OrderMapRoute extends _i30.PageRouteInfo<void> {
  const OrderMapRoute({List<_i30.PageRouteInfo>? children})
      : super(
          OrderMapRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderMapRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i18.OrderSuccess]
class OrderSuccess extends _i30.PageRouteInfo<void> {
  const OrderSuccess({List<_i30.PageRouteInfo>? children})
      : super(
          OrderSuccess.name,
          initialChildren: children,
        );

  static const String name = 'OrderSuccess';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i19.ProfileInfoPage]
class ProfileInfoRoute extends _i30.PageRouteInfo<ProfileInfoRouteArgs> {
  ProfileInfoRoute({
    _i31.Key? key,
    required _i33.UserModel user,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ProfileInfoRoute.name,
          args: ProfileInfoRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileInfoRoute';

  static const _i30.PageInfo<ProfileInfoRouteArgs> page =
      _i30.PageInfo<ProfileInfoRouteArgs>(name);
}

class ProfileInfoRouteArgs {
  const ProfileInfoRouteArgs({
    this.key,
    required this.user,
  });

  final _i31.Key? key;

  final _i33.UserModel user;

  @override
  String toString() {
    return 'ProfileInfoRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i20.ProfilePage]
class ProfileRoute extends _i30.PageRouteInfo<void> {
  const ProfileRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i21.RessetPasswordPage]
class RessetPasswordRoute extends _i30.PageRouteInfo<void> {
  const RessetPasswordRoute({List<_i30.PageRouteInfo>? children})
      : super(
          RessetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'RessetPasswordRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i22.RestorantPage]
class RestorantRoute extends _i30.PageRouteInfo<void> {
  const RestorantRoute({List<_i30.PageRouteInfo>? children})
      : super(
          RestorantRoute.name,
          initialChildren: children,
        );

  static const String name = 'RestorantRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i23.SalePage]
class SaleRoute extends _i30.PageRouteInfo<SaleRouteArgs> {
  SaleRoute({
    _i31.Key? key,
    _i34.SaleModel? sale,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SaleRoute.name,
          args: SaleRouteArgs(
            key: key,
            sale: sale,
          ),
          initialChildren: children,
        );

  static const String name = 'SaleRoute';

  static const _i30.PageInfo<SaleRouteArgs> page =
      _i30.PageInfo<SaleRouteArgs>(name);
}

class SaleRouteArgs {
  const SaleRouteArgs({
    this.key,
    this.sale,
  });

  final _i31.Key? key;

  final _i34.SaleModel? sale;

  @override
  String toString() {
    return 'SaleRouteArgs{key: $key, sale: $sale}';
  }
}

/// generated route for
/// [_i24.SearchMenuPage]
class SearchMenuRoute extends _i30.PageRouteInfo<void> {
  const SearchMenuRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SearchMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchMenuRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i25.SignInPage]
class SignInRoute extends _i30.PageRouteInfo<void> {
  const SignInRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i26.SignUpPage]
class SignUpRoute extends _i30.PageRouteInfo<void> {
  const SignUpRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i27.SignUpSucces]
class SignUpSucces extends _i30.PageRouteInfo<void> {
  const SignUpSucces({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpSucces.name,
          initialChildren: children,
        );

  static const String name = 'SignUpSucces';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i28.SplashScreen]
class SplashRoute extends _i30.PageRouteInfo<void> {
  const SplashRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}

/// generated route for
/// [_i29.VipPage]
class VipRoute extends _i30.PageRouteInfo<void> {
  const VipRoute({List<_i30.PageRouteInfo>? children})
      : super(
          VipRoute.name,
          initialChildren: children,
        );

  static const String name = 'VipRoute';

  static const _i30.PageInfo<void> page = _i30.PageInfo<void>(name);
}
