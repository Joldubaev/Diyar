import 'package:diyar/features/active_order/data/data.dart';
import 'package:diyar/injection_container.dart';
import 'domain/repositories/active_order_repositories.dart';
import 'presentation/cubit/active_order_cubit.dart';

activeOrderInjection() {
  // DATA SOURCES
  sl.registerLazySingleton<ActiveOrderRemoteDataSource>(() => ActiveOrderRemoteDataSourceImpl(sl(), sl()));
  // REPOSITORIES
  sl.registerSingleton<ActiveOrderRepository>(ActiveOrderRepositoryImpl(sl()));

  // BLOC
  sl.registerLazySingleton(() => ActiveOrderCubit(sl()));
}
