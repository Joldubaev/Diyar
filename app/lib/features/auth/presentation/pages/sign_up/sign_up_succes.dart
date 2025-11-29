import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SignUpSucces extends StatelessWidget {
  const SignUpSucces({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            var role = sl<SharedPreferences>().getString(AppConst.userRole);
            if (role?.toLowerCase() == "user".toLowerCase()) {
              context.router.pushAndPopUntil(
                const MainRoute(),
                predicate: (_) => false,
              );
            } else {
              context.router.pushAndPopUntil(
                const CurierRoute(),
                predicate: (_) => false,
              );
            }
          },
        ),
      ),
    );
  }
}
