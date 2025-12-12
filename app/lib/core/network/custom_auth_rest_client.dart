import 'package:dio/dio.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
// ignore: implementation_imports
import 'package:rest_client/src/network.dart';
import 'package:storage/storage.dart';

/// Кастомный AuthRestClient, который использует правильные ключи из AppConst
/// для чтения/записи токенов из PreferencesStorage
class CustomAuthRestClient extends RestClient {
  CustomAuthRestClient(Dio client, PreferencesStorage preferencesStorage)
      : super(client, errorHandler: NetworkErrorHandlerImpl()) {
    client.interceptors.add(
      AuthInterceptor(
        tokenGetter: () async => await preferencesStorage.read(AppConst.accessToken),
        refreshTokenGetter: () async => await preferencesStorage.read(AppConst.refreshToken),
        tokenSaver: (accessToken, refreshToken) async {
          await preferencesStorage.save(AppConst.accessToken, accessToken);
          await preferencesStorage.save(AppConst.refreshToken, refreshToken);
        },
        dio: client,
      ),
    );
  }
}
