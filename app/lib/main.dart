import 'dart:developer';
import 'package:diyar/features/map/presentation/presentation.dart';
import 'core/core.dart';
import 'features/app/cubit/remote_config_cubit.dart';
import 'features/pick_up/pick_up.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'features/cart/cart.dart';
import 'features/cart/data/models/cart_item_model_hive_adapter.dart';
import 'features/menu/data/models/food_model_hive_adapter.dart';
import 'features/features.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/app/view/app_listener.dart';
import 'core/shared/presentation/pages/app_wrapper_connection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(FoodModelAdapter());

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  Bloc.observer = const AppBlocObserver(onLog: log);

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebase.initializeApp();
  await di.init();

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
        BlocProvider(create: (context) => di.sl<InternetBloc>()..add(NetworkObserve())),
        BlocProvider(create: (context) => di.sl<SignUpCubit>()),
        BlocProvider(create: (context) => di.sl<SignInCubit>()),
        BlocProvider(create: (context) => di.sl<ProfileCubit>()),
        BlocProvider(create: (context) => di.sl<SignInCubit>()),
        BlocProvider(create: (context) => di.sl<CartBloc>()),
        BlocProvider(create: (context) => di.sl<MenuBloc>()),
        BlocProvider(create: (context) => di.sl<PopularCubit>()),
        BlocProvider(create: (context) => di.sl<OrderCubit>()),
        BlocProvider(create: (context) => di.sl<AboutUsCubit>()),
        BlocProvider(create: (context) => di.sl<HomeContentCubit>()),
        BlocProvider(create: (context) => di.sl<HistoryCubit>()),
        BlocProvider(create: (context) => di.sl<CurierCubit>()),
        BlocProvider(create: (context) => di.sl<RemoteConfigCubit>()),
        BlocProvider(create: (context) => di.sl<ThemeCubit>()),
        BlocProvider(create: (context) => di.sl<PickUpCubit>()),
        BlocProvider(create: (context) => di.sl<ActiveOrderCubit>()),
        BlocProvider(create: (context) => di.sl<PaymentBloc>()),
        BlocProvider(create: (context) => di.sl<SettingsCubit>()),
        BlocProvider(create: (context) => di.sl<UserMapCubit>()),
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
