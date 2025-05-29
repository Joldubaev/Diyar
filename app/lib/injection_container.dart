import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/about_us_injection.dart';
import 'package:diyar/features/active_order/active_order_injection.dart';
import 'package:diyar/features/auth/auth_injection.dart';
import 'package:diyar/features/cart/cart_injection.dart';
import 'package:diyar/features/curier/curier_injection.dart';
import 'package:diyar/features/history/history_injection.dart';
import 'package:diyar/features/home_content/home_content_injection.dart';
import 'package:diyar/features/menu/menu_injection.dart';
import 'package:diyar/features/order/order_injection.dart';
import 'package:diyar/features/payments/payments_injection.dart';
import 'package:diyar/features/pick_up/pick_up_injectin.dart';
import 'package:diyar/features/profile/profile_injection.dart';
import 'package:local_auth/local_auth.dart';
import 'features/app/cubit/remote_config_cubit.dart';
import 'features/settings/settings_injection.dart';
import 'shared/presentation/bloc/internet_bloc.dart';
import 'shared/presentation/cubit/popular_cubit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final packageInfo = await PackageInfo.fromPlatform();

  //! ⛳ Сначала — SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  await initNetworkInjections();
  await initLocalStorageInjections();
  await authInjection();
  await aboutUsInjection();
  await menuInjection();
  await cartInjection();
  await profileInjection();
  await homeContentInjection();
  await orderInjection();
  await pickUpInjection();
  await activeOrderInjection();
  await historyInjection();
  await curierInjection();
  await paymentsInjection();
  await settingsInjection();

  sl.registerFactory(() => PopularCubit(sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => RemoteConfigCubit(packageInfo: sl(), remoteConfig: sl<DiyarRemoteConfig>()));

  //! External
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerSingleton<PackageInfo>(packageInfo);

  // ✅ Remote config
  final remoteConfig = FirebaseRemoteConfig.instance;
  final diyarRemoteConfig = DiyarRemoteConfig(
    remoteConfig: remoteConfig,
    buildNumber: packageInfo.buildNumber,
  );
  await diyarRemoteConfig.initialise();
  sl.registerSingleton<DiyarRemoteConfig>(diyarRemoteConfig);
}

Future<void> initLocalStorageInjections() async {
  final prefs = await SharedPreferences.getInstance();
  // sl.registerSingleton<LocalNotificationService>(LocalNotificationService());

  sl.registerSingletonAsync<LocalStorage>(() async {
    return await LocalStorage.getInstance(prefs);
  });

  await sl.isReady<LocalStorage>();

  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
}

Future<void> initNetworkInjections() async {
  initRootLogger();
  DioNetwork.initDio();
  sl.registerLazySingleton<Dio>(() => DioNetwork.appAPI);
}
