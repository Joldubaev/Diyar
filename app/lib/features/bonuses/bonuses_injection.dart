
import 'package:diyar/features/bonuses/bonuses.dart';
import 'package:diyar/injection_container.dart';


bonusesInjection() {
  // REPOSITORIES
  sl.registerSingleton<BonusesRepository>(BonusesRepositoryImpl(sl()));

  // BLOC
  sl.registerLazySingleton(() => BonusesCubit(sl()));
}
