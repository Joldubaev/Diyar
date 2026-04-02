import 'package:dio/dio.dart';
import 'package:diyar/core/constants/api_const/api_const.dart';
import 'package:diyar/core/constants/app_const/app_const.dart';
import 'package:diyar/core/network/app_token_storage.dart';
import 'package:diyar/core/network/custom_auth_rest_client.dart';
import 'package:diyar/core/utils/storage/address_storage_service.dart';
import 'package:diyar/core/di/injectable_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:network/network.dart' as net;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_client/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

import 'package:geo/geo.dart';
import '../remote_config/diyar_remote_config.dart';
import '../utils/storage/local_storage.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  SecureStorage get secureStorage => SecureStorageImpl();

  @lazySingleton
  Dio get dio {
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
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<LocalStorage> get localStorage async {
    final prefs = await SharedPreferences.getInstance();
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
