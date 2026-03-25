import 'package:diyar/core/network/app_logger.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable_config.config.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => sl.init();

/// Точка входа инициализации DI (вызывать из main).
Future<void> init() async {
  initRootLogger();
  await configureDependencies();
}
