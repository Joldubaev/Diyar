import 'package:diyar/injection_container.dart';
import 'package:diyar/features/map/data/repositories/yandex_service.dart';
import 'package:diyar/features/map/data/repositories/price_repository.dart';
import 'package:diyar/features/map/data/datasource/remote_datasource.dart';
import 'package:diyar/features/map/presentation/cubit/user_map_cubit.dart';

mapInjection() {
  // Регистрируем сервис геолокации
  sl.registerLazySingleton<AppLocation>(
    () => LocationService(),
  );

  // Регистрируем RemoteDataSource
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(sl()),
  );

  // Регистрируем репозиторий цен
  sl.registerLazySingleton<PriceRepository>(
    () => PriceRepositoryImpl(sl<RemoteDataSource>()),
  );

  // Регистрируем кубит карты
  sl.registerFactory<UserMapCubit>(
    () => UserMapCubit(sl<PriceRepository>()),
  );
}
