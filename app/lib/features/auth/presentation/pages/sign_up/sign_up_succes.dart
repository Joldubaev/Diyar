import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/app_init/domain/domain.dart';
import 'package:diyar/features/security/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class SignUpSucces extends StatelessWidget {
  const SignUpSucces({super.key});
  
  void _navigateToHome(BuildContext context, NavigationRouteType routeType) {
    PageRouteInfo targetRoute;
    switch (routeType) {
      case NavigationRouteType.courier:
        targetRoute = const CurierRoute();
        break;
      case NavigationRouteType.main:
      default:
        targetRoute = const MainRoute();
        break;
    }
    context.router.pushAndPopUntil(targetRoute, predicate: (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PinCodeCubit, PinCodeState>(
      listener: (context, state) {
        if (state is PinCodeNavigationRouteLoaded) {
          _navigateToHome(context, state.routeType);
        } else if (state is PinCodeNavigationRouteFailure) {
          // Fallback to main route on error
          context.router.pushAndPopUntil(
            const MainRoute(),
            predicate: (_) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/check.svg',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    context.l10n.accountCreatedSuccessfully,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SubmitButtonWidget(
            title: context.l10n.next,
            bgColor: AppColors.primary,
            textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.white,
                ),
            onTap: () {
              context.read<PinCodeCubit>().getNavigationRoute();
            },
          ),
        ),
      ),
    );
  }
}
