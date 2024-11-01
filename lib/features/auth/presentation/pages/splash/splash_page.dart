import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/shared/constants/app_const/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _navigateToHome();
    });
  }

  Future<void> _navigateToHome() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(AppConst.userRole);
    log('SplashScreen: Retrieved user role - $role');
    if (!mounted) return;
    if (role == 'Courier') {
      log('SplashScreen: Redirecting to CurierRoute');
      context.router.pushAndPopUntil(
        const CurierRoute(),
        predicate: (_) => false,
      );
    } else {
      log('SplashScreen: Redirecting to MainRoute');
      context.router.pushAndPopUntil(
        const MainRoute(),
        predicate: (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
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
    );
  }
}
