import 'package:diyar/features/profile/prof.dart';
import 'package:diyar/injection_container.dart';

profileInjection() {
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl(), sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
}
