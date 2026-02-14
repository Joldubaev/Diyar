import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/features/app_init/presentation/presentation.dart';
import 'package:diyar/features/app_init/domain/domain.dart';
import 'package:diyar/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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
        context.read<SplashCubit>().checkAuthenticationStatus();
      }
    });
  }

  void _navigateBasedOnStatus(AuthenticationStatus status) {
    if (!mounted) return;

    final addressStorage = sl<AddressStorageService>();

    switch (status) {
      case AuthenticationStatus.firstLaunch:
        if (!addressStorage.isAddressSelected()) {
          log("[Splash] First launch, no address. Navigating to AddressSelectionRoute.");
          context.router.replace(const AddressSelectionRoute());
        } else {
          log("[Splash] First launch, address exists. Navigating to MainHomeRoute.");
          context.router.replace(const MainHomeRoute());
        }
        break;
      case AuthenticationStatus.unauthenticated:
        log("[Splash] Unauthenticated. Navigating to SignInRoute.");
        context.router.replace(const SignInRoute());
        break;
      case AuthenticationStatus.authenticated:
        final role = sl<LocalStorage>().getString(AppConst.userRole);
        if (role == "Courier") {
          log("[Splash] Authenticated. Role: Courier. Navigating to CurierRoute.");
          context.router.replace(const CurierRoute());
        } else if (!addressStorage.isAddressSelected()) {
          log("[Splash] Authenticated, no address. Navigating to AddressSelectionRoute.");
          context.router.replace(const AddressSelectionRoute());
        } else {
          log("[Splash] Authenticated. Navigating to MainHomeRoute.");
          context.router.replace(const MainHomeRoute());
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        log("[Splash] Received Cubit State: ${state.runtimeType}");
        if (state is SplashAuthenticationStatusLoaded) {
          final status = state.status;

          // Если токен истек, попробуем обновить
          if (status == AuthenticationStatus.unauthenticated) {
            context.read<SplashCubit>().refreshTokenIfNeeded();
          } else {
            _navigateBasedOnStatus(status);
          }
        } else if (state is SplashTokenRefreshed) {
          // После обновления токена проверяем статус снова
          context.read<SplashCubit>().checkAuthenticationStatus();
        } else if (state is SplashTokenRefreshFailed) {
          log("[Splash] Token refresh failed. Navigating to Sign In.");
          context.router.replace(const SignInRoute());
        } else if (state is SplashError) {
          log("[Splash] Error: ${state.message}");
          context.router.replace(const SignInRoute());
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
