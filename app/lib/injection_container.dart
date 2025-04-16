import 'package:dio/dio.dart';
import 'core/network/app_logger.dart';
import 'core/network/dio_network.dart';
import 'core/remote_config/diyar_remote_config.dart';
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
  // Initialize PackageInfo
  final packageInfo = await PackageInfo.fromPlatform();

  // Register cubits/blocs
  sl.registerFactory(() => SignUpCubit(sl(), sl()));
  sl.registerFactory(() => SignInCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerFactory(() => MenuCubit(sl()));
  sl.registerFactory(() => CartCubit(sl()));
  sl.registerFactory(() => PopularCubit(sl()));
  sl.registerFactory(() => OrderCubit(sl()));
  sl.registerFactory(() => AboutUsCubit(sl()));
  sl.registerFactory(() => HomeFeaturesCubit(sl()));
  sl.registerFactory(() => HistoryCubit(sl()));
  sl.registerFactory(() => CurierCubit(sl()));
  sl.registerFactory(() => InternetBloc());
  sl.registerFactory(() => RemoteConfigCubit(
      packageInfo: sl(), remoteConfig: sl<DiyarRemoteConfig>()));

  // Register repositories and data sources
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<AboutUsRepository>(
      () => AboutUsRepositoryImpl(sl()));
  sl.registerLazySingleton<AboutUsRemoteDataSource>(
      () => AboutUsRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(
      () => MenuRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeFeaturesRepositoryImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeFeaturesRepoImpl(sl()));

  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<CurierRepository>(() => CurierRepositoryImpl(sl()));
  sl.registerLazySingleton<CurierDataSource>(
      () => CurierDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(sl()));
  sl.registerLazySingleton<HistoryReDatasource>(
      () => HistoryReDatasourceImpl(sl(), sl()));

  sl.registerLazySingleton<SmsRepository>(() => SmsRepositoryImpl(sl()));
  sl.registerLazySingleton<SmsRemoteDataSource>(
      () => SmsRemoteDataSourceImpl(dio: sl()));

  //! Core
  await initNetworkInjections();

  //! External
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerSingleton<PackageInfo>(packageInfo);

  // Initialize FirebaseRemoteConfig
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Initialize and register DiyarRemoteConfig
  final diyarRemoteConfig = DiyarRemoteConfig(
    remoteConfig: remoteConfig,
    buildNumber: packageInfo.buildNumber,
  );

  // Initialize DiyarRemoteConfig
  await diyarRemoteConfig.initialise();
  sl.registerSingleton<DiyarRemoteConfig>(diyarRemoteConfig);

  // Register external dependencies
  final sharedPrefences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefences);
}

Future<void> initNetworkInjections() async {
  initRootLogger();
  DioNetwork.initDio();
  sl.registerLazySingleton<Dio>(() => DioNetwork.appAPI);
}
