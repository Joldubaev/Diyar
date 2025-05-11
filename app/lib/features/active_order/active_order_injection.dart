
import 'package:diyar/injection_container.dart';

import 'data/repository/active_order_repository.dart';
import 'domain/repositories/active_order_repositories.dart';
import 'presentation/cubit/active_order_cubit.dart';

activeOrderInjection() {
  // REPOSITORIES
  sl.registerSingleton<ActiveOrderRepository>(ActiveOrderRepositoryImpl(sl()));

  // BLOC
  sl.registerLazySingleton(() => ActiveOrderCubit(sl()));
}
