import 'dart:developer';
import 'package:diyar/core/core.dart';
import 'package:diyar/core/router/routes.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/firebase_options.dart';
import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/cubit/bloc/internet_bloc.dart';
import 'package:diyar/shared/cubit/popular_cubit.dart';
import 'package:diyar/shared/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:diyar/injection_container.dart' as di;
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:diyar/l10n/l10n.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'features/app/view/app_listener.dart';
import 'shared/cubit/theme/cubit/theme_cubit.dart';
import 'shared/pages/app_wrapper_connection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  Bloc.observer = const AppBlocObserver(onLog: log);

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  await init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const App());
  });
}

var appRoute = AppRouter();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<InternetBloc>()..add(NetworkObserve())),
        BlocProvider(create: (context) => di.sl<SignUpCubit>()),
        BlocProvider(create: (context) => di.sl<SignInCubit>()),
        BlocProvider(create: (context) => di.sl<ProfileCubit>()),
        BlocProvider(create: (context) => di.sl<SignInCubit>()),
        BlocProvider(create: (context) => di.sl<CartCubit>()),
        BlocProvider(create: (context) => di.sl<MenuCubit>()),
        BlocProvider(create: (context) => di.sl<PopularCubit>()),
        BlocProvider(create: (context) => di.sl<OrderCubit>()),
        BlocProvider(create: (context) => di.sl<AboutUsCubit>()),
        BlocProvider(create: (context) => di.sl<HomeFeaturesCubit>()),
        BlocProvider(create: (context) => di.sl<HistoryCubit>()),
        BlocProvider(create: (context) => di.sl<CurierCubit>()),
        BlocProvider(create: (context) => di.sl<RemoteConfigCubit>()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: AppListener(
        navigationKey: appRoute.navigatorKey,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: state.isDark ? darkTheme : lightTheme,
              themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
              routerConfig: appRoute.config(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('ru'),
              builder: (context, router) {
                return KeyboardDismisser(
                  gestures: const [
                    GestureType.onTap,
                    GestureType.onTapDown,
                    GestureType.onTapUp,
                  ],
                  child: AppWrapperConnectionPage(
                    child: router ?? const SizedBox(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
