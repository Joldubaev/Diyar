import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/shared/constants/app_const/app_const.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/utils/utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MainRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page),
            AutoRoute(page: MenuRoute.page),
            AutoRoute(page: OrderHistoryRoute.page),
            AutoRoute(page: ProfileRoute.page, guards: [AuthGuard()]),
          ],
        ),
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: CartRoute.page),
        AutoRoute(page: SearchMenuRoute.page),
        AutoRoute(page: ProfileInfoRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: ContactRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: PickupFormRoute.page),
        AutoRoute(page: SignUpSucces.page),
        AutoRoute(page: AboutUsRoute.page),
        AutoRoute(page: OrderMapRoute.page),
        AutoRoute(page: DeliveryFormRoute.page),
        AutoRoute(page: OrderDetailRoute.page),
        AutoRoute(page: RessetPasswordRoute.page),
        AutoRoute(page: CurierRoute.page),
        AutoRoute(page: HistoryRoute.page),
        AutoRoute(page: SaleRoute.page),
        AutoRoute(page: NewsRoute.page),
        AutoRoute(page: CofeRoute.page),
        AutoRoute(page: HallRoute.page),
        AutoRoute(page: VipRoute.page),
        AutoRoute(page: RestorantRoute.page),
        AutoRoute(page: SignUpOtpRoute.page),
        AutoRoute(page: ActiveOrderRoute.page),
        AutoRoute(page: UserOrderHistoryRoute.page),
        AutoRoute(page: UserPickupHistoryRoute.page),
        AutoRoute(page: UserPickupDetailRoute.page),
        AutoRoute(page: ProductDetailRoute.page),
      ];
}

class AuthGuard extends AutoRouteGuard {
  final prefs = sl<SharedPreferences>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final token = prefs.getString(AppConst.accessToken);
    final role = prefs.getString(AppConst.userRole);

    log('AuthGuard: Checking token and role');
    log('AuthGuard: Token - $token');
    log('AuthGuard: Role - $role');

    if (token == null || JwtDecoder.isExpired(token)) {
      log('AuthGuard: Session expired or token not found');
      showToast('Сессия истекла, войдите заново', isError: true);
      resolver.next(false);
      router.push(const SignInRoute());
    } else {
      if (role == 'Courier') {
        log('AuthGuard: Redirecting to CurierRoute');
        resolver.next(false);
        router.push(const CurierRoute());
      } else {
        log('AuthGuard: Proceeding to the requested route');
        resolver.next(true);
      }
    }
  }
}
