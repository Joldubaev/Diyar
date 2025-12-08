import 'package:dio/dio.dart';
import 'package:diyar/core/core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConst.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
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
  LocalAuthentication get localAuth => LocalAuthentication();

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
}
