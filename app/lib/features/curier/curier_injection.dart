import 'package:diyar/features/curier/curier.dart';
import 'package:diyar/injection_container.dart';

curierInjection(){

    sl.registerLazySingleton<CurierRepository>(() => CurierRepositoryImpl(sl()));
  sl.registerLazySingleton<CurierDataSource>(() => CurierDataSourceImpl(sl(), sl()));
    sl.registerFactory(() => CurierCubit(sl()));
}