import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'bootstrap.dart';
import 'core/core.dart';
import 'core/di/injectable_config.dart' as di;
import 'features/app/view/app_listener.dart';
import 'features/app/cubit/remote_config_cubit.dart';
import 'features/cart/cart.dart';
import 'features/features.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const App());
}

var appRoute = AppRouter();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<InternetBloc>()..add(NetworkObserve())),
        BlocProvider(create: (_) => di.sl<RemoteConfigCubit>()..init()),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()..add(LoadCart())),
        BlocProvider(create: (_) => di.sl<BonusCubit>()),
        BlocProvider(create: (_) => di.sl<AboutUsCubit>()),
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
              locale: const Locale('ru'),
              supportedLocales: AppLocalizations.supportedLocales,
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
