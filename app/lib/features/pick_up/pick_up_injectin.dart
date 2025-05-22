import 'package:diyar/features/pick_up/data/data.dart';
import 'package:diyar/features/pick_up/presentation/presentation.dart';
import 'package:diyar/injection_container.dart';

import 'domain/repositories/pick_up_repositories.dart';

pickUpInjection() {
  sl.registerFactory(() => PickUpCubit(sl()));
  sl.registerLazySingleton<PickUpRepositories>(() => PickUpRepository(sl()));
  sl.registerLazySingleton<RemotePickUpDataSource>(() => RemotePickUpDataSourceImpl(sl(), sl()));
}
