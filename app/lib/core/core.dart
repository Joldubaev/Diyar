// Core — порядок по Clean Architecture (см. README.md)
// 1) Error
export 'error/failure.dart';
export 'error/exception.dart';
// 2) Router
export 'router/routes.dart';
export 'router/routes.gr.dart';
// 3) DI
// (injectable_config — генерируется, подключается в main/injection)
// 4) Constants
export 'constants/constant.dart';
// 5) Theme
export 'theme/theme.dart';
// 6) Extensions
export 'extensions/bloc_read_safe.dart';
// 7) Network
export 'network/network.dart';
// 8) L10n
export 'l10n/l10n.dart';
// 9) Utils
export 'utils/utils.dart';
// 10) Shared (models + app-level presentation)
export 'shared/shared.dart';
// 11) Mixins
export 'mixins/repository_error_handler.dart';
// 12) Services
export 'services/map_service.dart';
// 13) Remote config
export 'remote_config/diyar_remote_config.dart';
// 14) Launch
export 'launch/launch.dart';
// 15) Components (re-export из common)
export 'components/components.dart';
