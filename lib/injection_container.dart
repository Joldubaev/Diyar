import 'package:dio/dio.dart';
import 'package:diyar/core/remote_config/diyar_remote_config.dart';
import 'package:diyar/features/app/cubit/remote_config_cubit.dart';
import 'package:diyar/features/cart/cart.dart';
import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/features/profile/data/data.dart';
import 'package:diyar/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:diyar/shared/cubit/bloc/internet_bloc.dart';
import 'package:diyar/shared/cubit/popular_cubit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'package:get_it/get_it.dart';

import 'features/cart/data/repository/cart_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final packageInfo = await PackageInfo.fromPlatform();

// cubit or bloc
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
  sl.registerFactory(
      () => RemoteConfigCubit(packageInfo: sl(), remoteConfig: sl()));

  // AUTH
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));

  // about us
  sl.registerLazySingleton<AboutUsRepository>(
      () => AboutUsRepositoryImpl(sl()));
  sl.registerLazySingleton<AboutUsRemoteDataSource>(
      () => AboutUsRemoteDataSourceImpl(sl(), sl()));

  // Profile
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl(), sl()));

  // sl.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl(sl()));
  // sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl(), sl()));

  // Menu
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(
      () => MenuRemoteDataSourceImpl(sl(), sl()));

  // HomeFeatures
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeFeaturesRepositoryImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeFeaturesRepoImpl(sl()));

  // Cart
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(sl()));

// Curier
  sl.registerLazySingleton<CurierRepository>(() => CurierRepositoryImpl(sl()));
  sl.registerLazySingleton<CurierDataSource>(
      () => CurierDataSourceImpl(sl(), sl()));
  // Order
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(sl(), sl()));

  // history
  sl.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(sl()));
  sl.registerLazySingleton<HistoryReDatasource>(
      () => HistoryReDatasourceImpl(sl(), sl()));

  // SMS Repository
  sl.registerLazySingleton<SmsRepository>(() => SmsRepositoryImpl(sl()));
  sl.registerLazySingleton<SmsRemoteDataSource>(
      () => SmsRemoteDataSourceImpl(dio: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

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

  final sharedPrefences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefences);
  sl.registerLazySingleton(() => Dio());
}
