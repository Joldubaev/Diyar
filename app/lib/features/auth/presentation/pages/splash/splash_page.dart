import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:diyar/features/auth/presentation/cubit/sign_in/sign_in_cubit.dart';
import 'package:diyar/injection_container.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final LocalStorage _localStorage = sl<LocalStorage>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAuthenticationCheck();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  void _startAuthenticationCheck() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _checkAuthentication();
      }
    });
  }

  Future<void> _checkAuthentication() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isFirstLaunch = prefs.getBool(AppConst.firstLaunch) ?? true;
      log('[Splash] Is first launch: $isFirstLaunch');
      if (isFirstLaunch) {
        log("[Splash] First launch detected. Navigating to SignInRoute.");
        _navigateTo(const MainRoute());
        return;
      }
      final String? refreshToken = _localStorage.getString(AppConst.refreshToken);
      final String? accessToken = _localStorage.getString(AppConst.accessToken);
      log('[Splash] Refresh Token: ${refreshToken != null ? 'Present' : 'Absent'}');
      if (refreshToken == null) {
        log("[Splash] Refresh token missing. Navigating to Sign In.");
        _navigateTo(const SignInRoute());
        return;
      }

      if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
        if (mounted) {
          context.read<SignInCubit>().refreshToken();
        }
      } else {
        log("[Splash] Access token is valid. Proceeding to user navigation.");
        _handleUserNavigation();
      }
    } catch (e, s) {
      log("[Splash] Error during authentication check: $e\n$s");
      _navigateTo(const SignInRoute());
    }
  }

  Future<void> _handleUserNavigation() async {
    try {
      final String? accessToken = _localStorage.getString(AppConst.accessToken);
      log('[Splash _handleUserNavigation] AccessToken READ from localStorage: $accessToken');
      log('[Splash _handleUserNavigation] Expected AccessToken key: ${AppConst.accessToken}');
      final String? pinCode = _localStorage.getString(AppConst.pinCode);
      log('[Splash] Handling navigation. AccessToken: ${accessToken != null ? 'Present' : 'Absent'}, PinCode: ${pinCode != null && pinCode.isNotEmpty ? 'Present' : 'Absent'}');
      if (!mounted) return;
      if (accessToken == null) {
        log('[Splash] Access token missing during navigation handling. Navigating to Sign In.');
        _navigateTo(const SignInRoute());
        return;
      }
      if (pinCode != null && pinCode.isNotEmpty) {
        log('[Splash] PIN code found. Navigating to PinCodeRoute.');
        _navigateTo(const PinCodeRoute());
      } else {
        log('[Splash] PIN code missing. Navigating to SetNewPinCodeRoute.');
        _navigateTo(const SetNewPinCodeRoute());
      }
    } catch (e, s) {
      log("[Splash] Error during user navigation handling: $e\n$s");
      _navigateTo(const SignInRoute());
    }
  }

  void _navigateTo(PageRouteInfo route) {
    if (mounted) {
      log('[Splash] Navigating to ${route.routeName}');
      context.router.replace(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        log("[Splash] Received Cubit State: ${state.runtimeType}");
        if (state is RefreshTokenLoaded) {
          log("[Splash] Token refresh successful. Proceeding to user navigation.");
          _handleUserNavigation();
        } else if (state is RefreshTokenFailure) {
          log("[Splash] Token refresh failed. Navigating to Sign In.");
          _navigateTo(const SignInRoute());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: FadeTransition(
          opacity: _fadeAnimation,
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
      ),
    );
  }
}
