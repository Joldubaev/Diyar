/// Unified network layer for Diyar.
///
/// Provides [RestClient], error handling via [AppFailure], and
/// interceptors for auth, locale, and logging.
library network;

export 'src/client/rest_client.dart';
export 'src/client/auth_rest_client.dart';
export 'src/client/unauth_rest_client.dart';
export 'src/error/app_failure.dart';
export 'src/error/failure_mapper.dart';
export 'src/error/server_error_body.dart';
export 'src/error/extended_error.dart';
export 'src/interceptors/auth_interceptor.dart';
export 'src/interceptors/locale_interceptor.dart';
export 'src/interceptors/logger_interceptor.dart';
export 'src/token/token_storage.dart';
export 'src/parser/data_parser.dart';
export 'src/network_info.dart';
