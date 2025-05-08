import 'package:diyar/features/home_content/data/datasource/home_content_remote_datasource.dart';
import 'package:diyar/features/home_content/domain/repositories/home_content_repository.dart';
import 'package:diyar/features/home_content/domain/usecases/get_news.dart';
import 'package:diyar/features/home_content/domain/usecases/get_sales.dart';
import 'package:diyar/features/home_content/presentation/cubit/home_content_cubit.dart';
import 'package:diyar/injection_container.dart';
import 'data/datasource/home_content_repository_impl.dart';

homeContentInjection() {
  sl.registerLazySingleton<HomeContentRemoteDatasource>(
      () => HomeContentRemoteDatasourceImpl(sl())); // Регистрируем реализацию Datasource

  // Repository
  sl.registerLazySingleton<HomeContentRepository>(
    // Регистрируем ИНТЕРФЕЙС
    () => HomeContentRepositoryImpl(remoteDataSource: sl()), // Предоставляем РЕАЛИЗАЦИЮ
  );

  // UseCases
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetSalesUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => HomeContentCubit(
      getNewsUseCase: sl(),
      getSalesUseCase: sl(),
      // Передаем use cases в конструктор Cubit
    ),
  );
}
