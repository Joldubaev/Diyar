import 'package:diyar/features/order/order.dart';
import 'package:diyar/injection_container.dart';

orderInjection() {
  sl.registerFactory(() => OrderCubit(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(sl(), sl()));
}
