import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  String? role;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadTokenAndRole();
    });
  }

  Future<void> _loadTokenAndRole() async {
    final sharedPreferences = sl<SharedPreferences>();
    token = sharedPreferences.getString(AppConst.accessToken);
    role = sharedPreferences.getString(AppConst.userRole);

    if (token != null && JwtDecoder.isExpired(token!)) {
      context.read<SignInCubit>().refreshToken();
    } else {
      _checkRoleAndPush();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is RefreshTokenLoaded) {
            _checkRoleAndPush();
          } else if (state is RefreshTokenFailure) {
            context.router.pushAndPopUntil(
              const SignInRoute(),
              predicate: (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/app_logo.png",
                  width: 150,
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkRoleAndPush() {
    if (role?.toLowerCase() == "user".toLowerCase()) {
      context.router.pushAndPopUntil(
        const MainRoute(),
        predicate: (_) => false,
      );
    } else if (role?.toLowerCase() == "courier".toLowerCase()) {
      context.router.pushAndPopUntil(
        const CurierRoute(),
        predicate: (_) => false,
      );
    } else {
      context.router.pushAndPopUntil(
        const SignInRoute(),
        predicate: (_) => false,
      );
    }
  }
}
