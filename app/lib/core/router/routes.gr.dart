// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i38;
import 'package:diyar/features/about_us/presentation/pages/about/about_us_page.dart'
    as _i1;
import 'package:diyar/features/about_us/presentation/pages/about/coffe_page.dart'
    as _i5;
import 'package:diyar/features/about_us/presentation/pages/about/hall_page.dart'
    as _i9;
import 'package:diyar/features/about_us/presentation/pages/about/restoran_page.dart'
    as _i23;
import 'package:diyar/features/about_us/presentation/pages/about/terasa_page.dart'
    as _i33;
import 'package:diyar/features/about_us/presentation/pages/about/vip_page.dart'
    as _i37;
import 'package:diyar/features/about_us/presentation/pages/contact/contact_page.dart'
    as _i6;
import 'package:diyar/features/auth/auth.dart' as _i44;
import 'package:diyar/features/auth/domain/domain.dart' as _i46;
import 'package:diyar/features/auth/presentation/pages/reset_password/reset_password_page.dart'
    as _i22;
import 'package:diyar/features/auth/presentation/pages/sign_in/sign_in_page.dart'
    as _i27;
import 'package:diyar/features/auth/presentation/pages/sign_up/check_phone_number_page.dart'
    as _i4;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_otp_page.dart'
    as _i28;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_page.dart'
    as _i29;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_succes.dart'
    as _i30;
import 'package:diyar/features/auth/presentation/pages/splash/splash_page.dart'
    as _i31;
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart'
    as _i41;
import 'package:diyar/features/cart/presentation/pages/cart_page.dart' as _i3;
import 'package:diyar/features/curier/presentation/pages/curier_page.dart'
    as _i7;
import 'package:diyar/features/curier/presentation/pages/history_page.dart'
    as _i10;
import 'package:diyar/features/history/data/model/user_pickup_history_model.dart'
    as _i47;
import 'package:diyar/features/history/presentation/pages/order_active/order_active_page.dart'
    as _i2;
import 'package:diyar/features/history/presentation/pages/order_active/order_detail_page.dart'
    as _i15;
import 'package:diyar/features/history/presentation/pages/order_history/user_order_history.dart'
    as _i34;
import 'package:diyar/features/history/presentation/pages/order_history_page.dart'
    as _i16;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_detail_page.dart'
    as _i35;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_history_page.dart'
    as _i36;
import 'package:diyar/features/map/presentation/user_map/order_map_page.dart'
    as _i17;
import 'package:diyar/features/menu/domain/domain.dart' as _i43;
import 'package:diyar/features/menu/presentation/pages/menu_page.dart' as _i13;
import 'package:diyar/features/menu/presentation/pages/product_detail_page.dart'
    as _i19;
import 'package:diyar/features/menu/presentation/pages/search_menu_page.dart'
    as _i25;
import 'package:diyar/features/order/data/models/distric_model.dart' as _i40;
import 'package:diyar/features/order/presentation/pages/delivery_page.dart'
    as _i8;
import 'package:diyar/features/order/presentation/pages/pickup_page.dart'
    as _i18;
import 'package:diyar/features/order/presentation/pages/second_order_page.dart'
    as _i26;
import 'package:diyar/features/profile/presentation/pages/profile/profile_page.dart'
    as _i21;
import 'package:diyar/features/profile/presentation/pages/profile_info/profile_info_page.dart'
    as _i20;
import 'package:diyar/features/sale_news/data/model/sale_model.dart' as _i45;
import 'package:diyar/features/sale_news/presentation/pages/news/news_page.dart'
    as _i14;
import 'package:diyar/features/sale_news/presentation/pages/sale/sale_page.dart'
    as _i24;
import 'package:diyar/features/templates/presentation/pages/templates_page.dart'
    as _i32;
import 'package:diyar/shared/pages/main_home/home_page.dart' as _i11;
import 'package:diyar/shared/pages/main_home/main_page.dart' as _i12;
import 'package:flutter/cupertino.dart' as _i42;
import 'package:flutter/material.dart' as _i39;

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsRoute extends _i38.PageRouteInfo<void> {
  const AboutUsRoute({List<_i38.PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutUsPage();
    },
  );
}

/// generated route for
/// [_i2.ActiveOrderPage]
class ActiveOrderRoute extends _i38.PageRouteInfo<void> {
  const ActiveOrderRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ActiveOrderRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActiveOrderRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActiveOrderPage();
    },
  );
}

/// generated route for
/// [_i3.CartPage]
class CartRoute extends _i38.PageRouteInfo<void> {
  const CartRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i3.CartPage();
    },
  );
}

/// generated route for
/// [_i4.CheckPhoneNumberPage]
class CheckPhoneNumberRoute extends _i38.PageRouteInfo<void> {
  const CheckPhoneNumberRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CheckPhoneNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckPhoneNumberRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i4.CheckPhoneNumberPage();
    },
  );
}

/// generated route for
/// [_i5.CofePage]
class CofeRoute extends _i38.PageRouteInfo<void> {
  const CofeRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CofeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CofeRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i5.CofePage();
    },
  );
}

/// generated route for
/// [_i6.ContactPage]
class ContactRoute extends _i38.PageRouteInfo<void> {
  const ContactRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i6.ContactPage();
    },
  );
}

/// generated route for
/// [_i7.CurierPage]
class CurierRoute extends _i38.PageRouteInfo<void> {
  const CurierRoute({List<_i38.PageRouteInfo>? children})
      : super(
          CurierRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurierRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i7.CurierPage();
    },
  );
}

/// generated route for
/// [_i8.DeliveryFormPage]
class DeliveryFormRoute extends _i38.PageRouteInfo<DeliveryFormRouteArgs> {
  DeliveryFormRoute({
    _i39.Key? key,
    _i40.DistricModel? distric,
    String? address,
    required List<_i41.CartItemEntity> cart,
    required int dishCount,
    required int totalPrice,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          DeliveryFormRoute.name,
          args: DeliveryFormRouteArgs(
            key: key,
            distric: distric,
            address: address,
            cart: cart,
            dishCount: dishCount,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryFormRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryFormRouteArgs>();
      return _i8.DeliveryFormPage(
        key: args.key,
        distric: args.distric,
        address: args.address,
        cart: args.cart,
        dishCount: args.dishCount,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class DeliveryFormRouteArgs {
  const DeliveryFormRouteArgs({
    this.key,
    this.distric,
    this.address,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
  });

  final _i39.Key? key;

  final _i40.DistricModel? distric;

  final String? address;

  final List<_i41.CartItemEntity> cart;

  final int dishCount;

  final int totalPrice;

  @override
  String toString() {
    return 'DeliveryFormRouteArgs{key: $key, distric: $distric, address: $address, cart: $cart, dishCount: $dishCount, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i9.HallPage]
class HallRoute extends _i38.PageRouteInfo<void> {
  const HallRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HallRoute.name,
          initialChildren: children,
        );

  static const String name = 'HallRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i9.HallPage();
    },
  );
}

/// generated route for
/// [_i10.HistoryPage]
class HistoryRoute extends _i38.PageRouteInfo<void> {
  const HistoryRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i10.HistoryPage();
    },
  );
}

/// generated route for
/// [_i11.HomePage]
class HomeRoute extends _i38.PageRouteInfo<void> {
  const HomeRoute({List<_i38.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomePage();
    },
  );
}

/// generated route for
/// [_i12.MainPage]
class MainRoute extends _i38.PageRouteInfo<void> {
  const MainRoute({List<_i38.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i12.MainPage();
    },
  );
}

/// generated route for
/// [_i13.MenuPage]
class MenuRoute extends _i38.PageRouteInfo<void> {
  const MenuRoute({List<_i38.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i13.MenuPage();
    },
  );
}

/// generated route for
/// [_i14.NewsPage]
class NewsRoute extends _i38.PageRouteInfo<void> {
  const NewsRoute({List<_i38.PageRouteInfo>? children})
      : super(
          NewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i14.NewsPage();
    },
  );
}

/// generated route for
/// [_i15.OrderDetailPage]
class OrderDetailRoute extends _i38.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i39.Key? key,
    required String orderNumber,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(
            key: key,
            orderNumber: orderNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return _i15.OrderDetailPage(
        key: args.key,
        orderNumber: args.orderNumber,
      );
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({
    this.key,
    required this.orderNumber,
  });

  final _i39.Key? key;

  final String orderNumber;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderNumber: $orderNumber}';
  }
}

/// generated route for
/// [_i16.OrderHistoryPage]
class OrderHistoryRoute extends _i38.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i38.PageRouteInfo>? children})
      : super(
          OrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderHistoryRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i16.OrderHistoryPage();
    },
  );
}

/// generated route for
/// [_i17.OrderMapPage]
class OrderMapRoute extends _i38.PageRouteInfo<OrderMapRouteArgs> {
  OrderMapRoute({
    _i39.Key? key,
    required List<_i41.CartItemEntity> cart,
    required int totalPrice,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderMapRouteArgs>();
      return _i17.OrderMapPage(
        key: args.key,
        cart: args.cart,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class OrderMapRouteArgs {
  const OrderMapRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
  });

  final _i39.Key? key;

  final List<_i41.CartItemEntity> cart;

  final int totalPrice;

  @override
  String toString() {
    return 'OrderMapRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i18.PickupFormPage]
class PickupFormRoute extends _i38.PageRouteInfo<PickupFormRouteArgs> {
  PickupFormRoute({
    _i42.Key? key,
    required List<_i41.CartItemEntity> cart,
    required int totalPrice,
    List<_i38.PageRouteInfo>? children,
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

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PickupFormRouteArgs>();
      return _i18.PickupFormPage(
        key: args.key,
        cart: args.cart,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class PickupFormRouteArgs {
  const PickupFormRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
  });

  final _i42.Key? key;

  final List<_i41.CartItemEntity> cart;

  final int totalPrice;

  @override
  String toString() {
    return 'PickupFormRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i19.ProductDetailPage]
class ProductDetailRoute extends _i38.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i39.Key? key,
    required _i43.FoodEntity food,
    int? quantity,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            food: food,
            quantity: quantity,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return _i19.ProductDetailPage(
        key: args.key,
        food: args.food,
        quantity: args.quantity,
      );
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.food,
    this.quantity,
  });

  final _i39.Key? key;

  final _i43.FoodEntity food;

  final int? quantity;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, food: $food, quantity: $quantity}';
  }
}

/// generated route for
/// [_i20.ProfileInfoPage]
class ProfileInfoRoute extends _i38.PageRouteInfo<ProfileInfoRouteArgs> {
  ProfileInfoRoute({
    _i39.Key? key,
    required _i44.UserModel user,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          ProfileInfoRoute.name,
          args: ProfileInfoRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileInfoRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileInfoRouteArgs>();
      return _i20.ProfileInfoPage(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class ProfileInfoRouteArgs {
  const ProfileInfoRouteArgs({
    this.key,
    required this.user,
  });

  final _i39.Key? key;

  final _i44.UserModel user;

  @override
  String toString() {
    return 'ProfileInfoRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i21.ProfilePage]
class ProfileRoute extends _i38.PageRouteInfo<void> {
  const ProfileRoute({List<_i38.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i21.ProfilePage();
    },
  );
}

/// generated route for
/// [_i22.RessetPasswordPage]
class RessetPasswordRoute extends _i38.PageRouteInfo<RessetPasswordRouteArgs> {
  RessetPasswordRoute({
    _i39.Key? key,
    String? phone,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          RessetPasswordRoute.name,
          args: RessetPasswordRouteArgs(
            key: key,
            phone: phone,
          ),
          initialChildren: children,
        );

  static const String name = 'RessetPasswordRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RessetPasswordRouteArgs>(
          orElse: () => const RessetPasswordRouteArgs());
      return _i22.RessetPasswordPage(
        key: args.key,
        phone: args.phone,
      );
    },
  );
}

class RessetPasswordRouteArgs {
  const RessetPasswordRouteArgs({
    this.key,
    this.phone,
  });

  final _i39.Key? key;

  final String? phone;

  @override
  String toString() {
    return 'RessetPasswordRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [_i23.RestorantPage]
class RestorantRoute extends _i38.PageRouteInfo<void> {
  const RestorantRoute({List<_i38.PageRouteInfo>? children})
      : super(
          RestorantRoute.name,
          initialChildren: children,
        );

  static const String name = 'RestorantRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i23.RestorantPage();
    },
  );
}

/// generated route for
/// [_i24.SalePage]
class SaleRoute extends _i38.PageRouteInfo<SaleRouteArgs> {
  SaleRoute({
    _i39.Key? key,
    _i45.SaleModel? sale,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SaleRoute.name,
          args: SaleRouteArgs(
            key: key,
            sale: sale,
          ),
          initialChildren: children,
        );

  static const String name = 'SaleRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SaleRouteArgs>(orElse: () => const SaleRouteArgs());
      return _i24.SalePage(
        key: args.key,
        sale: args.sale,
      );
    },
  );
}

class SaleRouteArgs {
  const SaleRouteArgs({
    this.key,
    this.sale,
  });

  final _i39.Key? key;

  final _i45.SaleModel? sale;

  @override
  String toString() {
    return 'SaleRouteArgs{key: $key, sale: $sale}';
  }
}

/// generated route for
/// [_i25.SearchMenuPage]
class SearchMenuRoute extends _i38.PageRouteInfo<void> {
  const SearchMenuRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SearchMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchMenuRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i25.SearchMenuPage();
    },
  );
}

/// generated route for
/// [_i26.SecondOrderPage]
class SecondOrderRoute extends _i38.PageRouteInfo<SecondOrderRouteArgs> {
  SecondOrderRoute({
    _i39.Key? key,
    required List<_i41.CartItemEntity> cart,
    required int dishCount,
    required int totalPrice,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SecondOrderRoute.name,
          args: SecondOrderRouteArgs(
            key: key,
            cart: cart,
            dishCount: dishCount,
            totalPrice: totalPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'SecondOrderRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SecondOrderRouteArgs>();
      return _i26.SecondOrderPage(
        key: args.key,
        cart: args.cart,
        dishCount: args.dishCount,
        totalPrice: args.totalPrice,
      );
    },
  );
}

class SecondOrderRouteArgs {
  const SecondOrderRouteArgs({
    this.key,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
  });

  final _i39.Key? key;

  final List<_i41.CartItemEntity> cart;

  final int dishCount;

  final int totalPrice;

  @override
  String toString() {
    return 'SecondOrderRouteArgs{key: $key, cart: $cart, dishCount: $dishCount, totalPrice: $totalPrice}';
  }
}

/// generated route for
/// [_i27.SignInPage]
class SignInRoute extends _i38.PageRouteInfo<void> {
  const SignInRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i27.SignInPage();
    },
  );
}

/// generated route for
/// [_i28.SignUpOtpPage]
class SignUpOtpRoute extends _i38.PageRouteInfo<SignUpOtpRouteArgs> {
  SignUpOtpRoute({
    _i39.Key? key,
    required _i46.UserEntities user,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SignUpOtpRoute.name,
          args: SignUpOtpRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpOtpRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpOtpRouteArgs>();
      return _i28.SignUpOtpPage(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class SignUpOtpRouteArgs {
  const SignUpOtpRouteArgs({
    this.key,
    required this.user,
  });

  final _i39.Key? key;

  final _i46.UserEntities user;

  @override
  String toString() {
    return 'SignUpOtpRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i29.SignUpPage]
class SignUpRoute extends _i38.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i39.Key? key,
    _i46.UserEntities? user,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          SignUpRoute.name,
          args: SignUpRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SignUpRouteArgs>(orElse: () => const SignUpRouteArgs());
      return _i29.SignUpPage(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class SignUpRouteArgs {
  const SignUpRouteArgs({
    this.key,
    this.user,
  });

  final _i39.Key? key;

  final _i46.UserEntities? user;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i30.SignUpSucces]
class SignUpSucces extends _i38.PageRouteInfo<void> {
  const SignUpSucces({List<_i38.PageRouteInfo>? children})
      : super(
          SignUpSucces.name,
          initialChildren: children,
        );

  static const String name = 'SignUpSucces';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i30.SignUpSucces();
    },
  );
}

/// generated route for
/// [_i31.SplashScreen]
class SplashRoute extends _i38.PageRouteInfo<void> {
  const SplashRoute({List<_i38.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i31.SplashScreen();
    },
  );
}

/// generated route for
/// [_i32.TemplatesPage]
class TemplatesRoute extends _i38.PageRouteInfo<void> {
  const TemplatesRoute({List<_i38.PageRouteInfo>? children})
      : super(
          TemplatesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TemplatesRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i32.TemplatesPage();
    },
  );
}

/// generated route for
/// [_i33.TerasaPage]
class TerasaRoute extends _i38.PageRouteInfo<void> {
  const TerasaRoute({List<_i38.PageRouteInfo>? children})
      : super(
          TerasaRoute.name,
          initialChildren: children,
        );

  static const String name = 'TerasaRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i33.TerasaPage();
    },
  );
}

/// generated route for
/// [_i34.UserOrderHistoryPage]
class UserOrderHistoryRoute extends _i38.PageRouteInfo<void> {
  const UserOrderHistoryRoute({List<_i38.PageRouteInfo>? children})
      : super(
          UserOrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserOrderHistoryRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i34.UserOrderHistoryPage();
    },
  );
}

/// generated route for
/// [_i35.UserPickupDetailPage]
class UserPickupDetailRoute
    extends _i38.PageRouteInfo<UserPickupDetailRouteArgs> {
  UserPickupDetailRoute({
    _i39.Key? key,
    required _i47.UserPickupHistoryModel order,
    List<_i38.PageRouteInfo>? children,
  }) : super(
          UserPickupDetailRoute.name,
          args: UserPickupDetailRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'UserPickupDetailRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserPickupDetailRouteArgs>();
      return _i35.UserPickupDetailPage(
        key: args.key,
        order: args.order,
      );
    },
  );
}

class UserPickupDetailRouteArgs {
  const UserPickupDetailRouteArgs({
    this.key,
    required this.order,
  });

  final _i39.Key? key;

  final _i47.UserPickupHistoryModel order;

  @override
  String toString() {
    return 'UserPickupDetailRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i36.UserPickupHistoryPage]
class UserPickupHistoryRoute extends _i38.PageRouteInfo<void> {
  const UserPickupHistoryRoute({List<_i38.PageRouteInfo>? children})
      : super(
          UserPickupHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserPickupHistoryRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i36.UserPickupHistoryPage();
    },
  );
}

/// generated route for
/// [_i37.VipPage]
class VipRoute extends _i38.PageRouteInfo<void> {
  const VipRoute({List<_i38.PageRouteInfo>? children})
      : super(
          VipRoute.name,
          initialChildren: children,
        );

  static const String name = 'VipRoute';

  static _i38.PageInfo page = _i38.PageInfo(
    name,
    builder: (data) {
      return const _i37.VipPage();
    },
  );
}
