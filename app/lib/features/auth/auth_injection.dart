import 'package:diyar/core/core.dart';
import 'package:diyar/features/auth/auth.dart';
import 'package:diyar/injection_container.dart';

import 'domain/repository/auth_repository.dart';

authInjection() {
  // DATA SOURCES
  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(sl()));
  sl.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(DioNetwork.appAPI, sl(), sl()));
  // REPOSITORIES
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl() ,sl()));

  // BLOC
  sl.registerFactory(() => SignInCubit(sl()));
  sl.registerFactory(() => SignUpCubit(sl()));
}