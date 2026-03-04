// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i45;
import 'package:diyar/features/about_us/presentation/pages/about/about_us_page.dart'
    as _i1;
import 'package:diyar/features/about_us/presentation/pages/about/coffe_page.dart'
    as _i8;
import 'package:diyar/features/about_us/presentation/pages/about/hall_page.dart'
    as _i12;
import 'package:diyar/features/about_us/presentation/pages/about/restoran_page.dart'
    as _i28;
import 'package:diyar/features/about_us/presentation/pages/about/terasa_page.dart'
    as _i40;
import 'package:diyar/features/about_us/presentation/pages/about/vip_page.dart'
    as _i44;
import 'package:diyar/features/about_us/presentation/pages/contact/contact_page.dart'
    as _i9;
import 'package:diyar/features/active_order/presentation/pages/order_active_page.dart'
    as _i2;
import 'package:diyar/features/app_init/presentation/pages/splash_page.dart'
    as _i38;
import 'package:diyar/features/auth/domain/domain.dart' as _i52;
import 'package:diyar/features/auth/presentation/pages/pin_code/pin_code_page.dart'
    as _i23;
import 'package:diyar/features/auth/presentation/pages/pin_code/set_new_pin_code_page.dart'
    as _i32;
import 'package:diyar/features/auth/presentation/pages/reset_password/reset_password_page.dart'
    as _i27;
import 'package:diyar/features/auth/presentation/pages/sign_in/sign_in_otp_page.dart'
    as _i33;
import 'package:diyar/features/auth/presentation/pages/sign_in/sign_in_page.dart'
    as _i34;
import 'package:diyar/features/auth/presentation/pages/sign_up/check_phone_number_page.dart'
    as _i7;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_otp_page.dart'
    as _i35;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_page.dart'
    as _i36;
import 'package:diyar/features/auth/presentation/pages/sign_up/sign_up_succes.dart'
    as _i37;
import 'package:diyar/features/bonus/presentation/pages/bonus_qr_page.dart'
    as _i4;
import 'package:diyar/features/bonus/presentation/pages/bonus_transactions_page.dart'
    as _i5;
import 'package:diyar/features/cart/cart.dart' as _i47;
import 'package:diyar/features/cart/domain/entities/cart_item_entity.dart'
    as _i48;
import 'package:diyar/features/cart/presentation/pages/cart_page.dart' as _i6;
import 'package:diyar/features/curier/presentation/pages/curier_page.dart'
    as _i10;
import 'package:diyar/features/curier/presentation/pages/history_page.dart'
    as _i13;
import 'package:diyar/features/history/domain/domain.dart' as _i53;
import 'package:diyar/features/history/presentation/pages/order_history/user_order_history.dart'
    as _i41;
import 'package:diyar/features/history/presentation/pages/order_history_page.dart'
    as _i20;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_detail_page.dart'
    as _i42;
import 'package:diyar/features/history/presentation/pages/pickup_history/user_pickup_history_page.dart'
    as _i43;
import 'package:diyar/features/home_content/domain/domain.dart' as _i51;
import 'package:diyar/features/home_content/presentation/pages/news/news_page.dart'
    as _i17;
import 'package:diyar/features/home_content/presentation/pages/sale/sale_page.dart'
    as _i29;
import 'package:diyar/features/main_home/presentation/pages/home_tab_page.dart'
    as _i14;
import 'package:diyar/features/main_home/presentation/pages/main_home_page.dart'
    as _i15;
import 'package:diyar/features/map/presentation/pages/address_selection_page.dart'
    as _i3;
import 'package:diyar/features/map/presentation/user_map/order_map_page.dart'
    as _i21;
import 'package:diyar/features/menu/domain/domain.dart' as _i49;
import 'package:diyar/features/menu/presentation/pages/menu_page.dart' as _i16;
import 'package:diyar/features/menu/presentation/pages/product_detail_page.dart'
    as _i24;
import 'package:diyar/features/menu/presentation/pages/search_menu_page.dart'
    as _i30;
import 'package:diyar/features/order/presentation/pages/delivery_page.dart'
    as _i11;
import 'package:diyar/features/order_detail/presentation/pages/order_detail_page.dart'
    as _i19;
import 'package:diyar/features/pick_up/presentation/pages/pickup_page.dart'
    as _i22;
import 'package:diyar/features/profile/data/data.dart' as _i50;
import 'package:diyar/features/profile/presentation/pages/profile/profile_page.dart'
    as _i26;
import 'package:diyar/features/profile/presentation/pages/profile_info/profile_info_page.dart'
    as _i25;
import 'package:diyar/features/profile/presentation/pages/security/security_page.dart'
    as _i31;
import 'package:diyar/features/templates/presentation/pages/templates_page.dart'
    as _i39;
import 'package:diyar/features/web_payment/presentation/pages/web_payment_page.dart'
    as _i18;
import 'package:flutter/material.dart' as _i46;

/// generated route for
/// [_i1.AboutUsPage]
class AboutUsRoute extends _i45.PageRouteInfo<void> {
  const AboutUsRoute({List<_i45.PageRouteInfo>? children})
      : super(
          AboutUsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutUsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutUsPage();
    },
  );
}

/// generated route for
/// [_i2.ActiveOrderPage]
class ActiveOrderRoute extends _i45.PageRouteInfo<void> {
  const ActiveOrderRoute({List<_i45.PageRouteInfo>? children})
      : super(
          ActiveOrderRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActiveOrderRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i2.ActiveOrderPage();
    },
  );
}

/// generated route for
/// [_i3.AddressSelectionPage]
class AddressSelectionRoute extends _i45.PageRouteInfo<void> {
  const AddressSelectionRoute({List<_i45.PageRouteInfo>? children})
      : super(
          AddressSelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddressSelectionRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i3.AddressSelectionPage();
    },
  );
}

/// generated route for
/// [_i4.BonusQrPage]
class BonusQrRoute extends _i45.PageRouteInfo<void> {
  const BonusQrRoute({List<_i45.PageRouteInfo>? children})
      : super(
          BonusQrRoute.name,
          initialChildren: children,
        );

  static const String name = 'BonusQrRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i4.BonusQrPage();
    },
  );
}

/// generated route for
/// [_i5.BonusTransactionsPage]
class BonusTransactionsRoute extends _i45.PageRouteInfo<void> {
  const BonusTransactionsRoute({List<_i45.PageRouteInfo>? children})
      : super(
          BonusTransactionsRoute.name,
          initialChildren: children,
        );

  static const String name = 'BonusTransactionsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i5.BonusTransactionsPage();
    },
  );
}

/// generated route for
/// [_i6.CartPage]
class CartRoute extends _i45.PageRouteInfo<void> {
  const CartRoute({List<_i45.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i6.CartPage();
    },
  );
}

/// generated route for
/// [_i7.CheckPhoneNumberPage]
class CheckPhoneNumberRoute extends _i45.PageRouteInfo<void> {
  const CheckPhoneNumberRoute({List<_i45.PageRouteInfo>? children})
      : super(
          CheckPhoneNumberRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckPhoneNumberRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i7.CheckPhoneNumberPage();
    },
  );
}

/// generated route for
/// [_i8.CofePage]
class CofeRoute extends _i45.PageRouteInfo<void> {
  const CofeRoute({List<_i45.PageRouteInfo>? children})
      : super(
          CofeRoute.name,
          initialChildren: children,
        );

  static const String name = 'CofeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i8.CofePage();
    },
  );
}

/// generated route for
/// [_i9.ContactPage]
class ContactRoute extends _i45.PageRouteInfo<void> {
  const ContactRoute({List<_i45.PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i9.ContactPage();
    },
  );
}

/// generated route for
/// [_i10.CurierPage]
class CurierRoute extends _i45.PageRouteInfo<void> {
  const CurierRoute({List<_i45.PageRouteInfo>? children})
      : super(
          CurierRoute.name,
          initialChildren: children,
        );

  static const String name = 'CurierRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i10.CurierPage();
    },
  );
}

/// generated route for
/// [_i11.DeliveryFormPage]
class DeliveryFormRoute extends _i45.PageRouteInfo<DeliveryFormRouteArgs> {
  DeliveryFormRoute({
    _i46.Key? key,
    String? address,
    String? initialUserName,
    String? initialUserPhone,
    required List<_i47.CartItemEntity> cart,
    required int dishCount,
    required int totalPrice,
    required double deliveryPrice,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          DeliveryFormRoute.name,
          args: DeliveryFormRouteArgs(
            key: key,
            address: address,
            initialUserName: initialUserName,
            initialUserPhone: initialUserPhone,
            cart: cart,
            dishCount: dishCount,
            totalPrice: totalPrice,
            deliveryPrice: deliveryPrice,
          ),
          initialChildren: children,
        );

  static const String name = 'DeliveryFormRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryFormRouteArgs>();
      return _i11.DeliveryFormPage(
        key: args.key,
        address: args.address,
        initialUserName: args.initialUserName,
        initialUserPhone: args.initialUserPhone,
        cart: args.cart,
        dishCount: args.dishCount,
        totalPrice: args.totalPrice,
        deliveryPrice: args.deliveryPrice,
      );
    },
  );
}

class DeliveryFormRouteArgs {
  const DeliveryFormRouteArgs({
    this.key,
    this.address,
    this.initialUserName,
    this.initialUserPhone,
    required this.cart,
    required this.dishCount,
    required this.totalPrice,
    required this.deliveryPrice,
  });

  final _i46.Key? key;

  final String? address;

  final String? initialUserName;

  final String? initialUserPhone;

  final List<_i47.CartItemEntity> cart;

  final int dishCount;

  final int totalPrice;

  final double deliveryPrice;

  @override
  String toString() {
    return 'DeliveryFormRouteArgs{key: $key, address: $address, initialUserName: $initialUserName, initialUserPhone: $initialUserPhone, cart: $cart, dishCount: $dishCount, totalPrice: $totalPrice, deliveryPrice: $deliveryPrice}';
  }
}

/// generated route for
/// [_i12.HallPage]
class HallRoute extends _i45.PageRouteInfo<void> {
  const HallRoute({List<_i45.PageRouteInfo>? children})
      : super(
          HallRoute.name,
          initialChildren: children,
        );

  static const String name = 'HallRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i12.HallPage();
    },
  );
}

/// generated route for
/// [_i13.HistoryPage]
class HistoryRoute extends _i45.PageRouteInfo<void> {
  const HistoryRoute({List<_i45.PageRouteInfo>? children})
      : super(
          HistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i13.HistoryPage();
    },
  );
}

/// generated route for
/// [_i14.HomeTabPage]
class HomeTabRoute extends _i45.PageRouteInfo<void> {
  const HomeTabRoute({List<_i45.PageRouteInfo>? children})
      : super(
          HomeTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeTabRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i14.HomeTabPage();
    },
  );
}

/// generated route for
/// [_i15.MainHomePage]
class MainHomeRoute extends _i45.PageRouteInfo<void> {
  const MainHomeRoute({List<_i45.PageRouteInfo>? children})
      : super(
          MainHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainHomeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i15.MainHomePage();
    },
  );
}

/// generated route for
/// [_i16.MenuPage]
class MenuRoute extends _i45.PageRouteInfo<void> {
  const MenuRoute({List<_i45.PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i16.MenuPage();
    },
  );
}

/// generated route for
/// [_i17.NewsPage]
class NewsRoute extends _i45.PageRouteInfo<void> {
  const NewsRoute({List<_i45.PageRouteInfo>? children})
      : super(
          NewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i17.NewsPage();
    },
  );
}

/// generated route for
/// [_i18.OpenBankingPaymentPage]
class OpenBankingPaymentRoute
    extends _i45.PageRouteInfo<OpenBankingPaymentRouteArgs> {
  OpenBankingPaymentRoute({
    _i46.Key? key,
    required String orderNumber,
    required int amount,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          OpenBankingPaymentRoute.name,
          args: OpenBankingPaymentRouteArgs(
            key: key,
            orderNumber: orderNumber,
            amount: amount,
          ),
          initialChildren: children,
        );

  static const String name = 'OpenBankingPaymentRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OpenBankingPaymentRouteArgs>();
      return _i18.OpenBankingPaymentPage(
        key: args.key,
        orderNumber: args.orderNumber,
        amount: args.amount,
      );
    },
  );
}

class OpenBankingPaymentRouteArgs {
  const OpenBankingPaymentRouteArgs({
    this.key,
    required this.orderNumber,
    required this.amount,
  });

  final _i46.Key? key;

  final String orderNumber;

  final int amount;

  @override
  String toString() {
    return 'OpenBankingPaymentRouteArgs{key: $key, orderNumber: $orderNumber, amount: $amount}';
  }
}

/// generated route for
/// [_i19.OrderDetailPage]
class OrderDetailRoute extends _i45.PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    _i46.Key? key,
    required String orderNumber,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          OrderDetailRoute.name,
          args: OrderDetailRouteArgs(
            key: key,
            orderNumber: orderNumber,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderDetailRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return _i19.OrderDetailPage(
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

  final _i46.Key? key;

  final String orderNumber;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, orderNumber: $orderNumber}';
  }
}

/// generated route for
/// [_i20.OrderHistoryPage]
class OrderHistoryRoute extends _i45.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i45.PageRouteInfo>? children})
      : super(
          OrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrderHistoryRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i20.OrderHistoryPage();
    },
  );
}

/// generated route for
/// [_i21.OrderMapPage]
class OrderMapRoute extends _i45.PageRouteInfo<OrderMapRouteArgs> {
  OrderMapRoute({
    _i46.Key? key,
    required List<_i48.CartItemEntity> cart,
    required int totalPrice,
    int? dishCount,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          OrderMapRoute.name,
          args: OrderMapRouteArgs(
            key: key,
            cart: cart,
            totalPrice: totalPrice,
            dishCount: dishCount,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderMapRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderMapRouteArgs>();
      return _i21.OrderMapPage(
        key: args.key,
        cart: args.cart,
        totalPrice: args.totalPrice,
        dishCount: args.dishCount,
      );
    },
  );
}

class OrderMapRouteArgs {
  const OrderMapRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
    this.dishCount,
  });

  final _i46.Key? key;

  final List<_i48.CartItemEntity> cart;

  final int totalPrice;

  final int? dishCount;

  @override
  String toString() {
    return 'OrderMapRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice, dishCount: $dishCount}';
  }
}

/// generated route for
/// [_i22.PickupFormPage]
class PickupFormRoute extends _i45.PageRouteInfo<PickupFormRouteArgs> {
  PickupFormRoute({
    _i46.Key? key,
    required List<_i47.CartItemEntity> cart,
    required int totalPrice,
    int? dishCount,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          PickupFormRoute.name,
          args: PickupFormRouteArgs(
            key: key,
            cart: cart,
            totalPrice: totalPrice,
            dishCount: dishCount,
          ),
          initialChildren: children,
        );

  static const String name = 'PickupFormRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PickupFormRouteArgs>();
      return _i22.PickupFormPage(
        key: args.key,
        cart: args.cart,
        totalPrice: args.totalPrice,
        dishCount: args.dishCount,
      );
    },
  );
}

class PickupFormRouteArgs {
  const PickupFormRouteArgs({
    this.key,
    required this.cart,
    required this.totalPrice,
    this.dishCount,
  });

  final _i46.Key? key;

  final List<_i47.CartItemEntity> cart;

  final int totalPrice;

  final int? dishCount;

  @override
  String toString() {
    return 'PickupFormRouteArgs{key: $key, cart: $cart, totalPrice: $totalPrice, dishCount: $dishCount}';
  }
}

/// generated route for
/// [_i23.PinCodePage]
class PinCodeRoute extends _i45.PageRouteInfo<void> {
  const PinCodeRoute({List<_i45.PageRouteInfo>? children})
      : super(
          PinCodeRoute.name,
          initialChildren: children,
        );

  static const String name = 'PinCodeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i23.PinCodePage();
    },
  );
}

/// generated route for
/// [_i24.ProductDetailPage]
class ProductDetailRoute extends _i45.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i46.Key? key,
    required _i49.FoodEntity food,
    int? quantity,
    List<_i45.PageRouteInfo>? children,
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

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return _i24.ProductDetailPage(
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

  final _i46.Key? key;

  final _i49.FoodEntity food;

  final int? quantity;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, food: $food, quantity: $quantity}';
  }
}

/// generated route for
/// [_i25.ProfileInfoPage]
class ProfileInfoRoute extends _i45.PageRouteInfo<ProfileInfoRouteArgs> {
  ProfileInfoRoute({
    _i46.Key? key,
    required _i50.UserProfileModel user,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          ProfileInfoRoute.name,
          args: ProfileInfoRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileInfoRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileInfoRouteArgs>();
      return _i25.ProfileInfoPage(
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

  final _i46.Key? key;

  final _i50.UserProfileModel user;

  @override
  String toString() {
    return 'ProfileInfoRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i26.ProfilePage]
class ProfileRoute extends _i45.PageRouteInfo<void> {
  const ProfileRoute({List<_i45.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i26.ProfilePage();
    },
  );
}

/// generated route for
/// [_i27.RessetPasswordPage]
class RessetPasswordRoute extends _i45.PageRouteInfo<RessetPasswordRouteArgs> {
  RessetPasswordRoute({
    _i46.Key? key,
    String? phone,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          RessetPasswordRoute.name,
          args: RessetPasswordRouteArgs(
            key: key,
            phone: phone,
          ),
          initialChildren: children,
        );

  static const String name = 'RessetPasswordRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RessetPasswordRouteArgs>(
          orElse: () => const RessetPasswordRouteArgs());
      return _i27.RessetPasswordPage(
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

  final _i46.Key? key;

  final String? phone;

  @override
  String toString() {
    return 'RessetPasswordRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [_i28.RestorantPage]
class RestorantRoute extends _i45.PageRouteInfo<void> {
  const RestorantRoute({List<_i45.PageRouteInfo>? children})
      : super(
          RestorantRoute.name,
          initialChildren: children,
        );

  static const String name = 'RestorantRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i28.RestorantPage();
    },
  );
}

/// generated route for
/// [_i29.SalePage]
class SaleRoute extends _i45.PageRouteInfo<SaleRouteArgs> {
  SaleRoute({
    _i46.Key? key,
    _i51.SaleEntity? sale,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          SaleRoute.name,
          args: SaleRouteArgs(
            key: key,
            sale: sale,
          ),
          initialChildren: children,
        );

  static const String name = 'SaleRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SaleRouteArgs>(orElse: () => const SaleRouteArgs());
      return _i29.SalePage(
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

  final _i46.Key? key;

  final _i51.SaleEntity? sale;

  @override
  String toString() {
    return 'SaleRouteArgs{key: $key, sale: $sale}';
  }
}

/// generated route for
/// [_i30.SearchMenuPage]
class SearchMenuRoute extends _i45.PageRouteInfo<void> {
  const SearchMenuRoute({List<_i45.PageRouteInfo>? children})
      : super(
          SearchMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchMenuRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i30.SearchMenuPage();
    },
  );
}

/// generated route for
/// [_i31.SecurityPage]
class SecurityRoute extends _i45.PageRouteInfo<void> {
  const SecurityRoute({List<_i45.PageRouteInfo>? children})
      : super(
          SecurityRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecurityRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i31.SecurityPage();
    },
  );
}

/// generated route for
/// [_i32.SetNewPinCodePage]
class SetNewPinCodeRoute extends _i45.PageRouteInfo<void> {
  const SetNewPinCodeRoute({List<_i45.PageRouteInfo>? children})
      : super(
          SetNewPinCodeRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetNewPinCodeRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i32.SetNewPinCodePage();
    },
  );
}

/// generated route for
/// [_i33.SignInOtpPage]
class SignInOtpRoute extends _i45.PageRouteInfo<SignInOtpRouteArgs> {
  SignInOtpRoute({
    _i46.Key? key,
    required String phone,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          SignInOtpRoute.name,
          args: SignInOtpRouteArgs(
            key: key,
            phone: phone,
          ),
          initialChildren: children,
        );

  static const String name = 'SignInOtpRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignInOtpRouteArgs>();
      return _i33.SignInOtpPage(
        key: args.key,
        phone: args.phone,
      );
    },
  );
}

class SignInOtpRouteArgs {
  const SignInOtpRouteArgs({
    this.key,
    required this.phone,
  });

  final _i46.Key? key;

  final String phone;

  @override
  String toString() {
    return 'SignInOtpRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [_i34.SignInPage]
class SignInRoute extends _i45.PageRouteInfo<void> {
  const SignInRoute({List<_i45.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i34.SignInPage();
    },
  );
}

/// generated route for
/// [_i35.SignUpOtpPage]
class SignUpOtpRoute extends _i45.PageRouteInfo<SignUpOtpRouteArgs> {
  SignUpOtpRoute({
    _i46.Key? key,
    required _i52.UserEntities user,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          SignUpOtpRoute.name,
          args: SignUpOtpRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpOtpRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpOtpRouteArgs>();
      return _i35.SignUpOtpPage(
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

  final _i46.Key? key;

  final _i52.UserEntities user;

  @override
  String toString() {
    return 'SignUpOtpRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i36.SignUpPage]
class SignUpRoute extends _i45.PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    _i46.Key? key,
    _i52.UserEntities? user,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          SignUpRoute.name,
          args: SignUpRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SignUpRouteArgs>(orElse: () => const SignUpRouteArgs());
      return _i36.SignUpPage(
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

  final _i46.Key? key;

  final _i52.UserEntities? user;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i37.SignUpSucces]
class SignUpSucces extends _i45.PageRouteInfo<void> {
  const SignUpSucces({List<_i45.PageRouteInfo>? children})
      : super(
          SignUpSucces.name,
          initialChildren: children,
        );

  static const String name = 'SignUpSucces';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i37.SignUpSucces();
    },
  );
}

/// generated route for
/// [_i38.SplashScreen]
class SplashRoute extends _i45.PageRouteInfo<void> {
  const SplashRoute({List<_i45.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i38.SplashScreen();
    },
  );
}

/// generated route for
/// [_i39.TemplatesPage]
class TemplatesRoute extends _i45.PageRouteInfo<void> {
  const TemplatesRoute({List<_i45.PageRouteInfo>? children})
      : super(
          TemplatesRoute.name,
          initialChildren: children,
        );

  static const String name = 'TemplatesRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i39.TemplatesPage();
    },
  );
}

/// generated route for
/// [_i40.TerasaPage]
class TerasaRoute extends _i45.PageRouteInfo<void> {
  const TerasaRoute({List<_i45.PageRouteInfo>? children})
      : super(
          TerasaRoute.name,
          initialChildren: children,
        );

  static const String name = 'TerasaRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i40.TerasaPage();
    },
  );
}

/// generated route for
/// [_i41.UserOrderHistoryPage]
class UserOrderHistoryRoute extends _i45.PageRouteInfo<void> {
  const UserOrderHistoryRoute({List<_i45.PageRouteInfo>? children})
      : super(
          UserOrderHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserOrderHistoryRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i41.UserOrderHistoryPage();
    },
  );
}

/// generated route for
/// [_i42.UserPickupDetailPage]
class UserPickupDetailRoute
    extends _i45.PageRouteInfo<UserPickupDetailRouteArgs> {
  UserPickupDetailRoute({
    _i46.Key? key,
    required _i53.UserPickupHistoryEntity order,
    List<_i45.PageRouteInfo>? children,
  }) : super(
          UserPickupDetailRoute.name,
          args: UserPickupDetailRouteArgs(
            key: key,
            order: order,
          ),
          initialChildren: children,
        );

  static const String name = 'UserPickupDetailRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserPickupDetailRouteArgs>();
      return _i42.UserPickupDetailPage(
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

  final _i46.Key? key;

  final _i53.UserPickupHistoryEntity order;

  @override
  String toString() {
    return 'UserPickupDetailRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i43.UserPickupHistoryPage]
class UserPickupHistoryRoute extends _i45.PageRouteInfo<void> {
  const UserPickupHistoryRoute({List<_i45.PageRouteInfo>? children})
      : super(
          UserPickupHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserPickupHistoryRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i43.UserPickupHistoryPage();
    },
  );
}

/// generated route for
/// [_i44.VipPage]
class VipRoute extends _i45.PageRouteInfo<void> {
  const VipRoute({List<_i45.PageRouteInfo>? children})
      : super(
          VipRoute.name,
          initialChildren: children,
        );

  static const String name = 'VipRoute';

  static _i45.PageInfo page = _i45.PageInfo(
    name,
    builder: (data) {
      return const _i44.VipPage();
    },
  );
}
