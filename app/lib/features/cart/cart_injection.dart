import 'dart:developer';

import 'package:diyar/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:diyar/features/cart/presentation/presentation.dart';
import 'package:diyar/injection_container.dart';
import 'data/datasources/cart_local_data_source.dart';
import 'domain/repository/cart_repository.dart';

cartInjection() async {
  // Внутри cart_injection.dart -> cartInjection()

  // Регистрируем DataSource (например, как LazySingleton)
  sl.registerLazySingleton<CartLocalDataSource>(() => CartHiveDataSource());

  // Регистрируем Repository и сразу инициализируем его
  sl.registerSingletonAsync<CartRepository>(() async {
    final dataSource = sl<CartLocalDataSource>(); // Получаем DataSource
    final repo = CartRepositoryImpl(dataSource); // Создаем репозиторий
    await repo.init(); // <<<--- ВЫЗЫВАЕМ INIT ЗДЕСЬ
    log("CartRepository initialized successfully."); // Для отладки
    return repo; // Возвращаем инициализированный репозиторий
  });

  // Убедимся, что репозиторий готов ПЕРЕД регистрацией Bloc
  await sl.isReady<CartRepository>();
  log("CartRepository is ready. Registering CartBloc..."); // Для отладки

  // Регистрируем Bloc (который теперь получит инициализированный репозиторий)
  sl.registerFactory(() => CartBloc(sl()));

  // <<<--- Вызываем LoadCart один раз ЗДЕСЬ --->>>
  sl<CartBloc>().add(LoadCart());
}
