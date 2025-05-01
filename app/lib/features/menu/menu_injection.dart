import 'package:diyar/core/core.dart';
import 'package:diyar/features/features.dart';
import 'package:diyar/injection_container.dart';

menuInjection() {
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSourceImpl(DioNetwork.appAPI));
  sl.registerFactory(() => MenuBloc(sl()));
}
