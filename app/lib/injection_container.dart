import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:diyar/features/about_us/about_us_injection.dart';
import 'package:diyar/features/auth/auth_injection.dart';
import 'features/app/cubit/remote_config_cubit.dart';
import 'features/cart/cart.dart';
import 'features/curier/curier.dart';
import 'features/features.dart';
import 'features/profile/data/data.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'shared/cubit/bloc/internet_bloc.dart';
import 'shared/cubit/popular_cubit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import 'features/cart/data/repository/cart_repository.dart';

final sl = GetIt.instance;
Future<void> init() async {
  final packageInfo = await PackageInfo.fromPlatform();

  //! ⛳ Сначала — SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Затем — Core (Dio и логгер)
  await initNetworkInjections();

  //! Затем — LocalStorage, который зависит от SharedPreferences
  await initLocalStorageInjections();

  //! Теперь — Auth, который зависит от всего выше
  await authInjection();

  // aboutUsInjection();
  await aboutUsInjection();

  // ✅ Остальная инициализация...
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerFactory(() => MenuCubit(sl()));
  sl.registerFactory(() => CartCubit(sl()));
  sl.registerFactory(() => PopularCubit(sl()));
  sl.registerFactory(() => OrderCubit(sl()));
  // sl.registerFactory(() => AboutUsCubit(sl()));
  sl.registerFactory(() => HomeFeaturesCubit(sl()));
  sl.registerFactory(() => HistoryCubit(sl()));
  sl.registerFactory(() => CurierCubit(sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => RemoteConfigCubit(packageInfo: sl(), remoteConfig: sl<DiyarRemoteConfig>()));

  // Register repositories and data sources
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl(), sl(), sl()));
  // sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  // sl.registerLazySingleton<AboutUsRepository>(() => AboutUsRepositoryImpl(sl()));
  // sl.registerLazySingleton<AboutUsRemoteDataSource>(() => AboutUsRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeFeaturesRepositoryImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeFeaturesRepoImpl(sl()));

  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<CurierRepository>(() => CurierRepositoryImpl(sl()));
  sl.registerLazySingleton<CurierDataSource>(() => CurierDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl(sl()));
  sl.registerLazySingleton<HistoryReDatasource>(() => HistoryReDatasourceImpl(sl(), sl()));

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
}

Future<void> initNetworkInjections() async {
  initRootLogger();
  DioNetwork.initDio();
  sl.registerLazySingleton<Dio>(() => DioNetwork.appAPI);
}
