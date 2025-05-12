import 'package:diyar/features/history/data/data.dart';
import 'package:diyar/features/history/domain/domain.dart';
import 'package:diyar/features/history/presentation/presentation.dart';
import 'package:diyar/injection_container.dart';

historyInjection(){

  // DATA SOURCES
  sl.registerLazySingleton<HistoryRepository>(() => HistoryRepositoryImpl(sl()));
  sl.registerLazySingleton<HistoryReDatasource>(() => HistoryReDatasourceImpl(sl(), sl()));
  // BLOC
  sl.registerFactory(() => HistoryCubit(sl()));

}