import 'dart:async';

import 'package:dio/dio.dart';
import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/core/network/app_token_storage.dart';
import 'package:diyar/core/network/custom_auth_rest_client.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:diyar/core/router/routes.dart';
import 'package:diyar/core/router/routes.gr.dart';
import 'package:diyar/features/auth/domain/domain.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:geo/geo.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:network/network.dart' as net;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';
import '../remote_config/diyar_remote_config.dart';
import '../utils/storage/local_storage.dart';

// Single-flight: пока идёт рефреш, параллельные 401 ждут одного Future.
Completer<void>? _tokenRefreshCompleter;

// Отдельный Dio без QueuedInterceptorsWrapper — используется только для
// /refresh-token, чтобы не создавать дедлок с основным Dio.
Dio? _refreshDio;

@module
abstract class RegisterModule {
  @lazySingleton
  SecureStorage get secureStorage => SecureStorageImpl();

  @lazySingleton
  Dio get dio {
    // Простой Dio без QueuedInterceptorsWrapper — только для /refresh-token.
    // Вызов рефреша через основной dio создаёт дедлок: onRequest нового
    // запроса встаёт в очередь QueuedInterceptorsWrapper, которая заблокирована
    // текущим onError. Используем отдельный инстанс, чтобы избежать этого.
    _refreshDio = Dio(BaseOptions(
      baseUrl: ApiConst.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (s) => s != null && s < 300,
      responseType: ResponseType.json,
    ));

    final dio = Dio(BaseOptions(
      baseUrl: ApiConst.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await sl<SecureStorage>().read(AppConst.accessToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final isAuthError = statusCode == 401 || statusCode == 403;
          final isRefreshRequest =
              error.requestOptions.path.contains('refresh-token');

          if (!isAuthError || isRefreshRequest) {
            return handler.next(error);
          }

          // Если токен в запросе уже отличается от текущего — рефреш уже
          // произошёл другим запросом (QueuedInterceptor обрабатывает
          // ошибки последовательно). Просто retry с новым токеном.
          final requestToken =
              error.requestOptions.headers['Authorization'] as String?;
          final currentToken =
              await sl<SecureStorage>().read(AppConst.accessToken);
          final tokenAlreadyRefreshed =
              currentToken != null && requestToken != 'Bearer $currentToken';

          if (!tokenAlreadyRefreshed) {
            if (_tokenRefreshCompleter != null) {
              final succeeded = await _tokenRefreshCompleter!.future
                  .then((_) => true)
                  .catchError((_) => false);
              if (!succeeded) return handler.reject(error);
            } else {
              _tokenRefreshCompleter = Completer<void>();
              try {
                final storedRefresh =
                    await sl<SecureStorage>().read(AppConst.refreshToken);
                if (storedRefresh == null) throw Exception('No refresh token');

                final response = await _refreshDio!.post(
                  ApiConst.refreshToken,
                  data: {'refreshToken': storedRefresh},
                );

                final data = response.data as Map<String, dynamic>;
                String? newAccess = data['accessToken'] as String?;
                String? newRefresh = data['refreshToken'] as String?;
                final msg = data['message'];
                if (msg is Map) {
                  newAccess ??= msg['accessToken'] as String?;
                  newRefresh ??= msg['refreshToken'] as String?;
                }
                if (newAccess == null) throw Exception('No access token');

                final refreshToSave = newRefresh ?? storedRefresh;
                await sl<SecureStorage>().save(AppConst.accessToken, newAccess);
                await sl<SecureStorage>()
                    .save(AppConst.refreshToken, refreshToSave);
                await sl<SharedPreferences>()
                    .setString(AppConst.accessToken, newAccess);
                await sl<SharedPreferences>()
                    .setString(AppConst.refreshToken, refreshToSave);

                _tokenRefreshCompleter!.complete();
              } catch (e) {
                _tokenRefreshCompleter!.completeError(e);
                _tokenRefreshCompleter = null;
                await sl<AuthRepository>().logout().catchError((_) {});
                sl<AppRouter>().replaceAll([const SignInRoute()]);
                return handler.reject(error);
              }
              _tokenRefreshCompleter = null;
            }
          }

          final newToken =
              await sl<SecureStorage>().read(AppConst.accessToken);
          if (newToken != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retried = await dio.fetch(error.requestOptions);
            return handler.resolve(retried);
          }

          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<LocalStorage> localStorage(SharedPreferences prefs) async {
    return await LocalStorage.getInstance(prefs);
  }

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @preResolve
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @preResolve
  Future<DiyarRemoteConfig> diyarRemoteConfig(PackageInfo packageInfo) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final diyarRemoteConfig = DiyarRemoteConfig(
      remoteConfig: remoteConfig,
      buildNumber: packageInfo.buildNumber,
    );
    await diyarRemoteConfig.initialise();
    return diyarRemoteConfig;
  }

  @lazySingleton
  AddressStorageService addressStorageService(LocalStorage localStorage) =>
      AddressStorageService(localStorage);

  @lazySingleton
  PreferencesStorage get preferencesStorage => PreferencesStorageImpl();

  /// TokenStorage from packages/network, backed by PreferencesStorage.
  @lazySingleton
  net.TokenStorage tokenStorage(PreferencesStorage preferencesStorage) =>
      AppTokenStorage(preferencesStorage);

  /// Delivery zone geometry from packages/geo.
  @lazySingleton
  ZoneRepository get zoneRepository => ZoneRepository();

  // -- Legacy REST clients (rest_client package, kept for backward compat) --

  @lazySingleton
  @Named('authRestClient')
  RestClient authRestClient(Dio dio, PreferencesStorage preferencesStorage) {
    return CustomAuthRestClient(dio, preferencesStorage);
  }

  @lazySingleton
  @Named('unauthRestClient')
  RestClient unauthRestClient(Dio dio) {
    return UnAuthRestClient(dio);
  }
}
