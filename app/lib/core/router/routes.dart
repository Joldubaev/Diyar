import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
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
        AutoRoute(page: CheckPhoneNumberRoute.page),
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
        AutoRoute(page: TerasaRoute.page),
        AutoRoute(page: SecondOrderRoute.page),
        AutoRoute(page: OrderHistoryRoute.page),

        // AutoRoute(page: TwoGisMapRoute.page),

      ];
}

class AuthGuard extends AutoRouteGuard {
  final prefs = sl<SharedPreferences>();
  final authDataSource = sl<AuthRemoteDataSource>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = prefs.getString(AppConst.accessToken);
    final role = prefs.getString(AppConst.userRole);

    log('AuthGuard: Checking token and role');
    log('AuthGuard: Token - $token');
    log('AuthGuard: Role - $role');

    // Проверка на наличие токена и его срок действия
    // if (token == null || JwtDecoder.isExpired(token)) {
    //   log('AuthGuard: Token отсутствует или истек');
    //   resolver.next(false);
    //   router.push(const SignInRoute());
    //   return;
    // }

    // Перенаправление в зависимости от роли
    if (role == 'Courier') {
      log('AuthGuard: Redirecting to CurierRoute');
      resolver.next(false);
      router.replace(const CurierRoute()); // Заменяем стек, чтобы нельзя было вернуться назад
    } else {
      log('AuthGuard: Redirecting to MainRoute');
      resolver.next(false);
      router.replace(const MainRoute()); // Заменяем стек
    }
  }
}
