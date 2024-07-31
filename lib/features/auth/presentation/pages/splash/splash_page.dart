import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/router/routes.gr.dart';
// import 'package:diyar/features/auth/auth.dart';
// import 'package:diyar/injection_container.dart';
// import 'package:diyar/shared/constants/constant.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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

  void _navigateToHome() {
    context.router.pushAndPopUntil(
      const MainRoute(),
      predicate: (_) => false,
    );
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
