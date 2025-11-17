import 'package:diyar/core/core.dart';
import 'package:diyar/di/injectable_config.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Инициализация логгера (нужна до других инициализаций)
  initRootLogger();
  
  // ✅ Все зависимости (SharedPreferences, Dio, LocalStorage, PackageInfo, etc.)
  //    теперь регистрируются через RegisterModule в injectable
  
  // Инициализация injectable (регистрирует классы с аннотациями @injectable, @lazySingleton и т.д.)
  // @preResolve зависимости (SharedPreferences, LocalStorage, PackageInfo, DiyarRemoteConfig)
  // будут автоматически разрешены до использования
  await configureDependencies();
  
  // authInjection() больше не нужен - теперь используется injectable
  // aboutUsInjection() больше не нужен - теперь используется injectable
  // menuInjection() больше не нужен - теперь используется injectable
  // cartInjection() больше не нужен - теперь используется injectable
  // profileInjection() больше не нужен - теперь используется injectable
  // homeContentInjection() больше не нужен - теперь используется injectable
  // orderInjection() больше не нужен - теперь используется injectable
  // pickUpInjection() больше не нужен - теперь используется injectable
  // activeOrderInjection() больше не нужен - теперь используется injectable
  // historyInjection() больше не нужен - теперь используется injectable
  // curierInjection() больше не нужен - теперь используется injectable
  // paymentsInjection() больше не нужен - теперь используется injectable
  // settingsInjection() больше не нужен - теперь используется injectable
  // mapInjection() больше не нужен - теперь используется injectable
  // PopularCubit теперь регистрируется через injectable
  // InternetBloc теперь регистрируется через injectable
  // ThemeCubit теперь регистрируется через injectable
  // RemoteConfigCubit теперь регистрируется через injectable
  // InternetConnection теперь регистрируется через RegisterModule в injectable
  // SharedPreferences, LocalStorage, Dio, PackageInfo, LocalAuthentication
  // теперь регистрируются через RegisterModule в injectable
}
