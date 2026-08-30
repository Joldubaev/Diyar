import 'package:rest_client/rest_client.dart';
import 'package:storage/storage.dart';

/// Авторизованный REST-клиент. Подстановка Bearer-токена и рефреш по 401
/// выполняются QueuedInterceptorsWrapper на общем Dio (см. RegisterModule.dio),
/// поэтому отдельный AuthInterceptor здесь не нужен — второй интерцептор
/// на том же Dio читал токен из SharedPreferences и слал refresh на
/// захардкоженный URL.
class CustomAuthRestClient extends RestClient {
  CustomAuthRestClient(super.client, PreferencesStorage preferencesStorage)
      : super(errorHandler: NetworkErrorHandlerImpl());
}
