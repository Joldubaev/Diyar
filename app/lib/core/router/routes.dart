import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/injection_container.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
        AutoRoute(page: ProfileInfoRoute.page),
        AutoRoute(page: ContactRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignInOtpRoute.page),
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
        // AutoRoute(page: OrderHistoryRoute.page),

        AutoRoute(page: PinCodeRoute.page),
        AutoRoute(page: SetNewPinCodeRoute.page),
        AutoRoute(page: SecurityRoute.page),
        AutoRoute(page: PaymentsRoute.page),
        AutoRoute(page: MegaCheckUserRoute.page),
        AutoRoute(page: MegaOtpRoute.page),
        AutoRoute(page: MegaPaymentStatusRoute.page),
        AutoRoute(page: QrCodeRoute.page),
        AutoRoute(page: QrCheckStatusRoute.page),
        AutoRoute(page: MbankConfirmRoute.page),
        AutoRoute(page: MbankCheckStatusRoute.page),
        AutoRoute(page: MbankInitiateRoute.page),
        AutoRoute(page: PaymentStatusRoute.page),
        AutoRoute(page: TemplatesRoute.page),
      ];
}

class AuthGuard extends AutoRouteGuard {
  final prefs = sl<LocalStorage>();
  final authDataSource = sl<AuthRemoteDataSource>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = prefs.getString(AppConst.accessToken);
    final role = prefs.getString(AppConst.userRole);

    log('AuthGuard: Checking token and role');
    log('AuthGuard: Token - $token');
    log('AuthGuard: Role - $role');

    // Проверка на наличие токена и его срок действия
    if (token == null || JwtDecoder.isExpired(token)) {
      log('AuthGuard: Token отсутствует или истек. Навигация на SignInRoute.');
      resolver.next(false); // Не разрешаем текущую навигацию
      router.pushAndPopUntil(const SignInRoute(),
          predicate: (route) => false); // Очищаем стек и переходим на SignInRoute
      return;
    }

    // Перенаправление в зависимости от роли
    if (role == 'Courier') {
      log('AuthGuard: Роль Courier. Перенаправление на CurierRoute.');
      resolver.next(false);
      router.replace(const CurierRoute()); // Заменяем стек, чтобы нельзя было вернуться назад
    } else if (role == 'admin') {
      log('AuthGuard: Роль Admin. Перенаправление на MainRoute.');
      resolver.next(false);
      router.replace(const MainRoute()); // Заменяем стек
    } else {
      log('AuthGuard: Роль User или другая (не Courier/Admin, роль: ${role ?? "null"}). Перенаправление на MainRoute.');
      resolver.next(false);
      router.replace(const MainRoute()); // Заменяем стек
    }
  }
}
