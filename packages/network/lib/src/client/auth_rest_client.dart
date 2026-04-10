import 'package:dio/dio.dart';
import 'package:network/src/client/rest_client.dart';
import 'package:network/src/error/failure_mapper.dart';
import 'package:network/src/interceptors/auth_interceptor.dart';
import 'package:network/src/token/token_storage.dart';

/// REST client that automatically attaches Bearer tokens and
/// handles token refresh on 401/403 via [AuthInterceptor].
class AuthRestClient extends RestClient {
  AuthRestClient(
    Dio dio, {
    required TokenStorage tokenStorage,
    String refreshEndpoint =
        'https://api.diyar.kg/api/v1/auth/refresh-token',
  }) : super(dio, errorHandler: NetworkErrorHandlerImpl()) {
    final interceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      dio: dio,
      refreshEndpoint: refreshEndpoint,
    );
    dio.interceptors.add(interceptor);
  }
}
