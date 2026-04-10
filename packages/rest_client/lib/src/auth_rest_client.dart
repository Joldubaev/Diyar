import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rest_client/src/network.dart';
import 'package:storage/storage.dart';

/// [AuthRestClient] - это специализированная версия [RestClient],
/// предназначенная для выполнения сетевых запросов, требующих аутентификации.
///
/// Он автоматически добавляет [AuthInterceptor] в цепочку перехватчиков Dio.
/// Этот перехватчик извлекает токен аутентификации из [SecureStorage]
/// и прикрепляет его к каждому запросу. Это избавляет от необходимости
/// вручную добавлять токен в каждый вызов API, который требует авторизации.
class AuthRestClient extends RestClient {
  AuthRestClient(this._client, PreferencesStorage secureStorage)
      : super(_client, errorHandler: NetworkErrorHandlerImpl()) {
    _client.interceptors.add(
      AuthInterceptor(
        tokenGetter: () async => await secureStorage.read('accessToken'),
        refreshTokenGetter: () async => await secureStorage.read('refreshToken'),
        tokenSaver: (accessToken, refreshToken) async {
          await secureStorage.save('accessToken', accessToken);
          await secureStorage.save('refreshToken', refreshToken);
        },
        dio: _client,
      ),
    );

    log('JWT TOKEN: ${secureStorage.read('accessToken')}');
  }

  final Dio _client;
}

