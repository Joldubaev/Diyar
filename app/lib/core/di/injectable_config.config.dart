// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core.dart' as _i156;
import '../remote_config/diyar_remote_config.dart' as _i413;
import '../../features/about_us/data/data.dart' as _i197;
import '../../features/about_us/data/remote_datasource/about_us_remote_datasource.dart'
    as _i669;
import '../../features/about_us/data/repository/repository.dart' as _i1060;
import '../../features/about_us/domain/domain.dart' as _i494;
import '../../features/about_us/presentation/cubit/about_us_cubit.dart' as _i776;
import '../../features/active_order/data/data.dart' as _i373;
import '../../features/active_order/data/datasource/remote_active_order_datasource.dart'
    as _i937;
import '../../features/active_order/data/repository/active_order_repository.dart'
    as _i44;
import '../../features/active_order/domain/domain.dart' as _i679;
import '../../features/active_order/presentation/cubit/active_order_cubit.dart'
    as _i297;
import '../../features/app/cubit/remote_config_cubit.dart' as _i239;
import '../../features/auth/data/datasources/local/auth_local_data_source.dart'
    as _i148;
import '../../features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i236;
import '../../features/auth/data/repositories/auth_repository.dart' as _i243;
import '../../features/auth/domain/domain.dart' as _i968;
import '../../features/auth/presentation/cubit/sign_in/sign_in_cubit.dart' as _i89;
import '../../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart'
    as _i760;
import '../../features/bonuses/bonuses.dart' as _i499;
import '../../features/bonuses/data/repository/bonuses_repository.dart' as _i773;
import '../../features/bonuses/presentation/cubit/bonuses_cubit.dart' as _i591;
import '../../features/cart/data/cart_module.dart' as _i214;
import '../../features/cart/data/datasources/cart_local_data_source.dart' as _i502;
import '../../features/cart/domain/repository/cart_repository.dart' as _i491;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i421;
import '../../features/curier/curier.dart' as _i450;
import '../../features/curier/data/datasource/curier_data_source.dart' as _i322;
import '../../features/curier/data/repositories/curier_repository.dart' as _i53;
import '../../features/curier/presentation/cubit/curier_cubit.dart' as _i800;
import '../../features/history/data/data_source/history_re_datasource.dart'
    as _i339;
import '../../features/history/data/repositories/history_repositories.dart'
    as _i165;
import '../../features/history/domain/domain.dart' as _i283;
import '../../features/history/history.dart' as _i539;
import '../../features/history/presentation/cubit/history_cubit.dart' as _i791;
import '../../features/home_content/data/datasource/home_content_remote_datasource.dart'
    as _i553;
import '../../features/home_content/data/datasource/home_content_repository_impl.dart'
    as _i753;
import '../../features/home_content/domain/repositories/home_content_repository.dart'
    as _i622;
import '../../features/home_content/domain/usecases/get_news.dart' as _i371;
import '../../features/home_content/domain/usecases/get_sales.dart' as _i626;
import '../../features/home_content/presentation/cubit/home_content_cubit.dart'
    as _i1025;
import '../../features/map/data/datasource/remote_datasource.dart' as _i294;
import '../../features/map/data/repositories/price_repository.dart' as _i188;
import '../../features/map/data/repositories/yandex_service.dart' as _i750;
import '../../features/map/presentation/cubit/user_map_cubit.dart' as _i368;
import '../../features/menu/data/datasources/remote_datasource/menu_remote_data_sources.dart'
    as _i223;
import '../../features/menu/data/repositories/menu_repository.dart' as _i527;
import '../../features/menu/domain/domain.dart' as _i728;
import '../../features/menu/menu.dart' as _i708;
import '../../features/menu/presentation/bloc/menu_bloc.dart' as _i49;
import '../../features/order/data/datasources/order_remote_datasource.dart'
    as _i1010;
import '../../features/order/data/repository/order_repository.dart' as _i276;
import '../../features/order/domain/repositories/order_repositories.dart' as _i405;
import '../../features/order/presentation/cubit/order_cubit.dart' as _i767;
import '../../features/payments/data/datasource/remote_payments_datasource.dart'
    as _i922;
import '../../features/payments/data/repository/payments_repository.dart' as _i579;
import '../../features/payments/domain/domain.dart' as _i1055;
import '../../features/payments/domain/usecase/mbank_confirm_usecase.dart'
    as _i383;
import '../../features/payments/domain/usecase/mbank_initiate_usecase.dart'
    as _i725;
import '../../features/payments/domain/usecase/mbank_status_usecase.dart' as _i382;
import '../../features/payments/domain/usecase/mega_check_usecase.dart' as _i308;
import '../../features/payments/domain/usecase/mega_initiate_usecase.dart'
    as _i394;
import '../../features/payments/domain/usecase/mega_status_usecase.dart' as _i861;
import '../../features/payments/domain/usecase/qr_check_status_usecase.dart'
    as _i417;
import '../../features/payments/domain/usecase/qr_code_usecase.dart' as _i381;
import '../../features/payments/payments.dart' as _i721;
import '../../features/payments/presentation/bloc/payment_bloc.dart' as _i488;
import '../../features/pick_up/data/datasource/remote_pick_up_datasource.dart'
    as _i987;
import '../../features/pick_up/data/repository/pick_up_repository.dart' as _i414;
import '../../features/pick_up/domain/repositories/pick_up_repositories.dart'
    as _i698;
import '../../features/pick_up/pick_up.dart' as _i31;
import '../../features/pick_up/presentation/cubit/pick_up_cubit.dart' as _i13;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i1053;
import '../../features/profile/data/repositories/profile_repository.dart' as _i537;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i300;
import '../../features/profile/profile.dart' as _i443;
import '../../features/settings/data/datasource/remote_settings_datasource.dart'
    as _i187;
import '../../features/settings/data/repository/settings_repository.dart' as _i34;
import '../../features/settings/domain/domain.dart' as _i498;
import '../../features/settings/domain/repositories/settings_repositories.dart'
    as _i259;
import '../../features/settings/presentation/cubit/settings_cubit.dart' as _i692;
import '../../features/templates/presentation/cubit/templates_cubit.dart' as _i738;
import '../shared/presentation/bloc/internet_bloc.dart' as _i231;
import '../shared/presentation/cubit/popular_cubit.dart' as _i1012;
import '../shared/presentation/theme_cubit/theme_cubit.dart' as _i489;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final cartModule = _$CartModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i156.LocalStorage>(
      () => registerModule.localStorage,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i738.TemplatesCubit>(() => _i738.TemplatesCubit());
    gh.singleton<_i231.InternetBloc>(() => _i231.InternetBloc());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.lazySingleton<_i161.InternetConnection>(
        () => registerModule.internetConnection);
    gh.lazySingleton<_i502.CartLocalDataSource>(
        () => _i502.CartHiveDataSource());
    gh.factory<_i489.ThemeCubit>(
        () => _i489.ThemeCubit(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i669.AboutUsRemoteDataSource>(
        () => _i669.AboutUsRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i156.LocalStorage>(),
            ));
    gh.lazySingleton<_i148.AuthLocalDataSource>(
        () => _i148.AuthLocalDataSourceImpl(gh<_i156.LocalStorage>()));
    gh.lazySingleton<_i294.RemoteDataSource>(
        () => _i294.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i922.RemotePaymentsDatasource>(
        () => _i922.RemotePaymentsDatasourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i499.BonusesRepository>(
        () => _i773.BonusesRepositoryImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i553.HomeContentRemoteDatasource>(
        () => _i753.HomeContentRemoteDatasourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i1053.ProfileRemoteDataSource>(
        () => _i1053.ProfileRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i156.LocalStorage>(),
            ));
    gh.lazySingleton<_i537.ProfileRepository>(
        () => _i537.ProfileRepositoryImpl(gh<_i443.ProfileRemoteDataSource>()));
    gh.lazySingleton<_i187.RemoteSettingsDataSource>(
        () => _i187.RemoteSettingsDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i498.SettingsRepository>(() =>
        _i34.SettingsRepositoryImpl(gh<_i187.RemoteSettingsDataSource>()));
    gh.lazySingleton<_i223.MenuRemoteDataSource>(
        () => _i223.MenuRemoteDataSourceImpl(gh<_i361.Dio>()));
    await gh.factoryAsync<_i491.CartRepository>(
      () => cartModule.cartRepository(gh<_i502.CartLocalDataSource>()),
      preResolve: true,
    );
    await gh.factoryAsync<_i156.DiyarRemoteConfig>(
      () => registerModule.diyarRemoteConfig(gh<_i655.PackageInfo>()),
      preResolve: true,
    );
    gh.lazySingleton<_i1010.OrderRemoteDataSource>(
        () => _i1010.OrderRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i188.PriceRepository>(
        () => _i188.PriceRepositoryImpl(gh<_i294.RemoteDataSource>()));
    gh.lazySingleton<_i322.CurierDataSource>(() => _i322.CurierDataSourceImpl(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i987.RemotePickUpDataSource>(
        () => _i987.RemotePickUpDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i622.HomeContentRepository>(() =>
        _i753.HomeContentRepositoryImpl(
            remoteDataSource: gh<_i553.HomeContentRemoteDatasource>()));
    gh.lazySingleton<_i1055.PaymentsRepository>(() =>
        _i579.PaymentsRepositoryImpl(gh<_i922.RemotePaymentsDatasource>()));
    gh.lazySingleton<_i937.ActiveOrderRemoteDataSource>(
        () => _i937.ActiveOrderRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i339.HistoryReDatasource>(
        () => _i339.HistoryReDatasourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.factory<_i591.BonusesCubit>(
        () => _i591.BonusesCubit(gh<_i499.BonusesRepository>()));
    gh.factory<_i421.CartBloc>(
        () => _i421.CartBloc(gh<_i491.CartRepository>()));
    gh.lazySingleton<_i236.AuthRemoteDataSource>(
        () => _i236.AuthRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i148.AuthLocalDataSource>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i750.AppLocation>(() => _i750.LocationService(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i708.MenuRepository>(
        () => _i527.MenuRepositoryImpl(gh<_i708.MenuRemoteDataSource>()));
    gh.lazySingleton<_i968.AuthRepository>(() => _i243.AuthRepositoryImpl(
          gh<_i236.AuthRemoteDataSource>(),
          gh<_i148.AuthLocalDataSource>(),
        ));
    gh.factory<_i239.RemoteConfigCubit>(() => _i239.RemoteConfigCubit(
          packageInfo: gh<_i655.PackageInfo>(),
          remoteConfig: gh<_i413.DiyarRemoteConfig>(),
        ));
    gh.lazySingleton<_i494.AboutUsRepository>(() =>
        _i1060.AboutUsRepositoryImpl(gh<_i197.AboutUsRemoteDataSource>()));
    gh.factory<_i300.ProfileCubit>(
        () => _i300.ProfileCubit(gh<_i443.ProfileRepository>()));
    gh.factory<_i776.AboutUsCubit>(
        () => _i776.AboutUsCubit(gh<_i494.AboutUsRepository>()));
    gh.factory<_i394.MegaInitiateUsecase>(
        () => _i394.MegaInitiateUsecase(gh<_i721.PaymentsRepository>()));
    gh.factory<_i725.MbankInitiateUsecase>(
        () => _i725.MbankInitiateUsecase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i382.MbankStatusUsecase>(
        () => _i382.MbankStatusUsecase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i381.QrCodeUsecase>(
        () => _i381.QrCodeUsecase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i308.MegaCheckUseCase>(
        () => _i308.MegaCheckUseCase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i861.MegaStatusUsecase>(
        () => _i861.MegaStatusUsecase(gh<_i721.PaymentsRepository>()));
    gh.factory<_i383.MbankConfimUsecase>(
        () => _i383.MbankConfimUsecase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i417.QrCheckStatusUsecase>(
        () => _i417.QrCheckStatusUsecase(gh<_i1055.PaymentsRepository>()));
    gh.factory<_i89.SignInCubit>(() => _i89.SignInCubit(
          gh<_i968.AuthRepository>(),
          gh<_i156.LocalStorage>(),
          gh<_i152.LocalAuthentication>(),
        ));
    gh.factory<_i371.GetNewsUseCase>(
        () => _i371.GetNewsUseCase(gh<_i622.HomeContentRepository>()));
    gh.factory<_i626.GetSalesUseCase>(
        () => _i626.GetSalesUseCase(gh<_i622.HomeContentRepository>()));
    gh.factory<_i692.SettingsCubit>(
        () => _i692.SettingsCubit(gh<_i259.SettingsRepository>()));
    gh.lazySingleton<_i31.PickUpRepositories>(
        () => _i414.PickUpRepository(gh<_i31.RemotePickUpDataSource>()));
    gh.factory<_i368.UserMapCubit>(() => _i368.UserMapCubit(
          gh<_i188.PriceRepository>(),
          gh<_i750.AppLocation>(),
        ));
    gh.lazySingleton<_i283.HistoryRepository>(
        () => _i165.HistoryRepositoryImpl(gh<_i539.HistoryReDatasource>()));
    gh.lazySingleton<_i405.OrderRepository>(
        () => _i276.OrderRepositoryImpl(gh<_i1010.OrderRemoteDataSource>()));
    gh.factory<_i488.PaymentBloc>(() => _i488.PaymentBloc(
          gh<_i1055.MegaCheckUseCase>(),
          gh<_i1055.MegaInitiateUsecase>(),
          gh<_i1055.MegaStatusUsecase>(),
          gh<_i1055.QrCodeUsecase>(),
          gh<_i1055.MbankInitiateUsecase>(),
          gh<_i1055.MbankConfimUsecase>(),
          gh<_i1055.MbankStatusUsecase>(),
        ));
    gh.lazySingleton<_i679.ActiveOrderRepository>(() =>
        _i44.ActiveOrderRepositoryImpl(
            gh<_i373.ActiveOrderRemoteDataSource>()));
    gh.factory<_i49.MenuBloc>(() => _i49.MenuBloc(gh<_i728.MenuRepository>()));
    gh.factory<_i1012.PopularCubit>(
        () => _i1012.PopularCubit(gh<_i728.MenuRepository>()));
    gh.lazySingleton<_i450.CurierRepository>(
        () => _i53.CurierRepositoryImpl(gh<_i450.CurierDataSource>()));
    gh.factory<_i791.HistoryCubit>(
        () => _i791.HistoryCubit(gh<_i283.HistoryRepository>()));
    gh.factory<_i760.SignUpCubit>(
        () => _i760.SignUpCubit(gh<_i968.AuthRepository>()));
    gh.factory<_i13.PickUpCubit>(
        () => _i13.PickUpCubit(gh<_i698.PickUpRepositories>()));
    gh.factory<_i800.CurierCubit>(
        () => _i800.CurierCubit(gh<_i450.CurierRepository>()));
    gh.factory<_i1025.HomeContentCubit>(() => _i1025.HomeContentCubit(
          getNewsUseCase: gh<_i371.GetNewsUseCase>(),
          getSalesUseCase: gh<_i626.GetSalesUseCase>(),
        ));
    gh.factory<_i297.ActiveOrderCubit>(
        () => _i297.ActiveOrderCubit(gh<_i679.ActiveOrderRepository>()));
    gh.factory<_i767.OrderCubit>(
        () => _i767.OrderCubit(gh<_i405.OrderRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$CartModule extends _i214.CartModule {}
