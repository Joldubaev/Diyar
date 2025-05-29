
import 'package:diyar/injection_container.dart';

import 'data/datasource/remote_settings_datasource.dart';
import 'data/repository/settings_repository.dart';
import 'domain/domain.dart';
import 'presentation/cubit/settings_cubit.dart';

settingsInjection() {

  // DATA SOURCES
  sl.registerLazySingleton<RemoteSettingsDataSource>(() => RemoteSettingsDataSourceImpl(sl()));
  // REPOSITORIES
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl(sl()));

  // BLOC
  sl.registerLazySingleton(() => SettingsCubit(sl()));
}
