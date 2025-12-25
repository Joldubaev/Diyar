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
import 'package:rest_client/rest_client.dart' as _i1030;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:storage/storage.dart' as _i431;

import '../../common/calculiator/order_calculation_service.dart' as _i804;
import '../../features/about_us/data/data.dart' as _i798;
import '../../features/about_us/data/remote_datasource/about_us_remote_datasource.dart'
    as _i243;
import '../../features/about_us/data/repository/repository.dart' as _i471;
import '../../features/about_us/domain/domain.dart' as _i168;
import '../../features/about_us/presentation/cubit/about_us_cubit.dart'
    as _i573;
import '../../features/active_order/data/data.dart' as _i311;
import '../../features/active_order/data/datasource/remote_active_order_datasource.dart'
    as _i283;
import '../../features/active_order/data/repository/active_order_repository.dart'
    as _i243;
import '../../features/active_order/domain/domain.dart' as _i74;
import '../../features/active_order/presentation/cubit/active_order_cubit.dart'
    as _i60;
import '../../features/app/cubit/remote_config_cubit.dart' as _i122;
import '../../features/auth/data/datasources/local/auth_local_data_source.dart'
    as _i835;
import '../../features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i520;
import '../../features/auth/data/datasources/remote/auth_remote_datasource_impl.dart'
    as _i415;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/domain/domain.dart' as _i140;
import '../../features/auth/domain/usecases/authenticate_with_biometrics_usecase.dart'
    as _i349;
import '../../features/auth/domain/usecases/check_biometrics_availability_usecase.dart'
    as _i35;
import '../../features/auth/domain/usecases/refresh_token_if_needed_usecase.dart'
    as _i550;
import '../../features/auth/domain/usecases/verify_sms_code_and_handle_first_launch_usecase.dart'
    as _i952;
import '../../features/auth/presentation/cubit/sign_in/sign_in_cubit.dart'
    as _i302;
import '../../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart'
    as _i781;
import '../../features/bonus/bonus.dart' as _i475;
import '../../features/bonus/data/datasources/bonus_remote_datasource.dart'
    as _i805;
import '../../features/bonus/data/repository/bonus_repository_impl.dart'
    as _i966;
import '../../features/bonus/domain/domain.dart' as _i135;
import '../../features/bonus/domain/repositories/bonus_repository.dart'
    as _i361;
import '../../features/bonus/domain/usecases/generate_qr_usecase.dart' as _i360;
import '../../features/bonus/presentation/cubit/bonus_cubit.dart' as _i968;
import '../../features/bonuses/bonuses.dart' as _i806;
import '../../features/bonuses/data/repository/bonuses_repository.dart'
    as _i275;
import '../../features/bonuses/presentation/cubit/bonuses_cubit.dart' as _i0;
import '../../features/cart/data/cart_module.dart' as _i979;
import '../../features/cart/data/datasources/cart_local_data_source.dart'
    as _i706;
import '../../features/cart/domain/domain.dart' as _i885;
import '../../features/cart/domain/repository/cart_repository.dart' as _i26;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i517;
import '../../features/cart/presentation/cubit/cart_cutlery_cubit.dart'
    as _i512;
import '../../features/cart/presentation/cubit/cart_price_cubit.dart' as _i132;
import '../../features/curier/curier.dart' as _i566;
import '../../features/curier/data/datasource/curier_data_source.dart' as _i614;
import '../../features/curier/data/repositories/curier_repository.dart'
    as _i537;
import '../../features/curier/presentation/cubit/curier_cubit.dart' as _i110;
import '../../features/history/data/data_source/history_re_datasource.dart'
    as _i49;
import '../../features/history/data/repositories/history_repositories.dart'
    as _i178;
import '../../features/history/domain/domain.dart' as _i408;
import '../../features/history/history.dart' as _i926;
import '../../features/history/presentation/cubit/history_cubit.dart' as _i232;
import '../../features/home_content/data/datasource/home_content_remote_datasource.dart'
    as _i521;
import '../../features/home_content/data/datasource/home_content_repository_impl.dart'
    as _i347;
import '../../features/home_content/domain/repositories/home_content_repository.dart'
    as _i477;
import '../../features/home_content/domain/usecases/get_news.dart' as _i31;
import '../../features/home_content/domain/usecases/get_sales.dart' as _i608;
import '../../features/home_content/presentation/cubit/home_content_cubit.dart'
    as _i812;
import '../../features/map/data/datasource/remote_datasource.dart' as _i337;
import '../../features/map/data/repositories/price_repository.dart' as _i659;
import '../../features/map/data/repositories/yandex_service.dart' as _i835;
import '../../features/map/presentation/cubit/user_map_cubit.dart' as _i661;
import '../../features/menu/data/datasources/remote_datasource/menu_remote_data_sources.dart'
    as _i433;
import '../../features/menu/data/repositories/menu_repository.dart' as _i1024;
import '../../features/menu/domain/domain.dart' as _i872;
import '../../features/menu/menu.dart' as _i660;
import '../../features/menu/presentation/bloc/menu_bloc.dart' as _i395;
import '../../features/order/data/datasources/order_remote_datasource.dart'
    as _i773;
import '../../features/order/data/repository/order_repository.dart' as _i576;
import '../../features/order/domain/repositories/order_repositories.dart'
    as _i758;
import '../../features/order/domain/usecases/validate_order_data_usecase.dart'
    as _i679;
import '../../features/order/order.dart' as _i830;
import '../../features/order/presentation/cubit/delivery_form_cubit.dart'
    as _i431;
import '../../features/order/presentation/cubit/order_cubit.dart' as _i304;
import '../../features/payments/data/datasource/remote_payments_datasource.dart'
    as _i1005;
import '../../features/payments/data/repository/payments_repository.dart'
    as _i944;
import '../../features/payments/domain/domain.dart' as _i838;
import '../../features/payments/domain/usecase/mbank_confirm_usecase.dart'
    as _i427;
import '../../features/payments/domain/usecase/mbank_initiate_usecase.dart'
    as _i985;
import '../../features/payments/domain/usecase/mbank_status_usecase.dart'
    as _i134;
import '../../features/payments/domain/usecase/mega_check_usecase.dart'
    as _i283;
import '../../features/payments/domain/usecase/mega_initiate_usecase.dart'
    as _i982;
import '../../features/payments/domain/usecase/mega_status_usecase.dart'
    as _i561;
import '../../features/payments/domain/usecase/qr_check_status_usecase.dart'
    as _i286;
import '../../features/payments/domain/usecase/qr_code_usecase.dart' as _i299;
import '../../features/payments/payments.dart' as _i971;
import '../../features/payments/presentation/bloc/payment_bloc.dart' as _i849;
import '../../features/pick_up/data/datasource/remote_pick_up_datasource.dart'
    as _i39;
import '../../features/pick_up/data/repository/pick_up_repository.dart'
    as _i123;
import '../../features/pick_up/domain/repositories/pick_up_repositories.dart'
    as _i292;
import '../../features/pick_up/pick_up.dart' as _i54;
import '../../features/pick_up/presentation/cubit/pick_up_cubit.dart' as _i370;
import '../../features/profile/data/datasources/profile_remote_data_source.dart'
    as _i847;
import '../../features/profile/data/repositories/profile_repository.dart'
    as _i361;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/profile/profile.dart' as _i315;
import '../../features/settings/data/datasource/remote_settings_datasource.dart'
    as _i300;
import '../../features/settings/data/repository/settings_repository.dart'
    as _i87;
import '../../features/settings/domain/domain.dart' as _i879;
import '../../features/settings/domain/repositories/settings_repositories.dart'
    as _i635;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/templates/data/datasources/template_remote_data_source.dart'
    as _i251;
import '../../features/templates/data/datasources/template_remote_datasource_impl.dart'
    as _i692;
import '../../features/templates/data/repository/template_repository.dart'
    as _i843;
import '../../features/templates/domain/repository/template_repository.dart'
    as _i411;
import '../../features/templates/domain/usecases/create_template_usecase.dart'
    as _i77;
import '../../features/templates/domain/usecases/delete_template_usecase.dart'
    as _i298;
import '../../features/templates/domain/usecases/get_template_by_id_usecase.dart'
    as _i844;
import '../../features/templates/domain/usecases/get_templates_usecase.dart'
    as _i230;
import '../../features/templates/domain/usecases/prepare_delivery_navigation_usecase.dart'
    as _i198;
import '../../features/templates/domain/usecases/update_template_usecase.dart'
    as _i968;
import '../../features/templates/presentation/cubit/templates_list_cubit.dart'
    as _i423;
import '../core.dart' as _i351;
import '../remote_config/diyar_remote_config.dart' as _i1020;
import '../shared/presentation/bloc/internet_bloc.dart' as _i231;
import '../shared/presentation/cubit/popular_cubit.dart' as _i1012;
import '../shared/presentation/theme_cubit/theme_cubit.dart' as _i489;
import '../utils/storage/local_storage.dart' as _i31;
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
    await gh.factoryAsync<_i351.LocalStorage>(
      () => registerModule.localStorage,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i512.CartCutleryCubit>(() => _i512.CartCutleryCubit());
    gh.factory<_i198.PrepareDeliveryNavigationUseCase>(
        () => _i198.PrepareDeliveryNavigationUseCase());
    gh.singleton<_i231.InternetBloc>(() => _i231.InternetBloc());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.lazySingleton<_i161.InternetConnection>(
        () => registerModule.internetConnection);
    gh.lazySingleton<_i431.PreferencesStorage>(
        () => registerModule.preferencesStorage);
    gh.lazySingleton<_i804.OrderCalculationService>(
        () => _i804.OrderCalculationService());
    gh.lazySingleton<_i706.CartLocalDataSource>(
        () => _i706.CartHiveDataSource());
    gh.factory<_i489.ThemeCubit>(
        () => _i489.ThemeCubit(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i243.AboutUsRemoteDataSource>(
        () => _i243.AboutUsRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.factory<_i349.AuthenticateWithBiometricsUseCase>(
        () => _i349.AuthenticateWithBiometricsUseCase(
              gh<_i152.LocalAuthentication>(),
              gh<_i31.LocalStorage>(),
            ));
    gh.factory<_i35.CheckBiometricsAvailabilityUseCase>(
        () => _i35.CheckBiometricsAvailabilityUseCase(
              gh<_i152.LocalAuthentication>(),
              gh<_i31.LocalStorage>(),
            ));
    gh.lazySingleton<_i835.AuthLocalDataSource>(
        () => _i835.AuthLocalDataSourceImpl(gh<_i351.LocalStorage>()));
    gh.lazySingleton<_i337.RemoteDataSource>(
        () => _i337.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i1005.RemotePaymentsDatasource>(
        () => _i1005.RemotePaymentsDatasourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i1030.RestClient>(
      () => registerModule.unauthRestClient(gh<_i361.Dio>()),
      instanceName: 'unauthRestClient',
    );
    gh.lazySingleton<_i806.BonusesRepository>(
        () => _i275.BonusesRepositoryImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i521.HomeContentRemoteDatasource>(
        () => _i347.HomeContentRemoteDatasourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i847.ProfileRemoteDataSource>(
        () => _i847.ProfileRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.lazySingleton<_i361.ProfileRepository>(
        () => _i361.ProfileRepositoryImpl(gh<_i315.ProfileRemoteDataSource>()));
    gh.lazySingleton<_i300.RemoteSettingsDataSource>(
        () => _i300.RemoteSettingsDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i805.BonusRemoteDataSource>(
        () => _i805.BonusRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i879.SettingsRepository>(() =>
        _i87.SettingsRepositoryImpl(gh<_i300.RemoteSettingsDataSource>()));
    gh.lazySingleton<_i433.MenuRemoteDataSource>(
        () => _i433.MenuRemoteDataSourceImpl(gh<_i361.Dio>()));
    await gh.factoryAsync<_i351.DiyarRemoteConfig>(
      () => registerModule.diyarRemoteConfig(gh<_i655.PackageInfo>()),
      preResolve: true,
    );
    gh.lazySingleton<_i773.OrderRemoteDataSource>(
        () => _i773.OrderRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i659.PriceRepository>(
        () => _i659.PriceRepositoryImpl(gh<_i337.RemoteDataSource>()));
    gh.lazySingleton<_i614.CurierDataSource>(() => _i614.CurierDataSourceImpl(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i39.RemotePickUpDataSource>(
        () => _i39.RemotePickUpDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i520.AuthRemoteDataSource>(
        () => _i415.AuthRemoteDataSourceImpl(
              gh<_i1030.RestClient>(instanceName: 'unauthRestClient'),
              gh<_i835.AuthLocalDataSource>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.lazySingleton<_i477.HomeContentRepository>(() =>
        _i347.HomeContentRepositoryImpl(
            remoteDataSource: gh<_i521.HomeContentRemoteDatasource>()));
    gh.lazySingleton<_i838.PaymentsRepository>(() =>
        _i944.PaymentsRepositoryImpl(gh<_i1005.RemotePaymentsDatasource>()));
    await gh.factoryAsync<_i26.CartRepository>(
      () => cartModule.cartRepository(gh<_i706.CartLocalDataSource>()),
      preResolve: true,
    );
    gh.lazySingleton<_i283.ActiveOrderRemoteDataSource>(
        () => _i283.ActiveOrderRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i49.HistoryReDatasource>(
        () => _i49.HistoryReDatasourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.factory<_i0.BonusesCubit>(
        () => _i0.BonusesCubit(gh<_i806.BonusesRepository>()));
    gh.factory<_i132.CartPriceCubit>(() => _i132.CartPriceCubit(
          gh<_i804.OrderCalculationService>(),
          initialItems: gh<List<_i885.CartItemEntity>>(),
        ));
    gh.lazySingleton<_i835.AppLocation>(() => _i835.LocationService(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.factory<_i679.ValidateOrderDataUseCase>(() =>
        _i679.ValidateOrderDataUseCase(gh<_i804.OrderCalculationService>()));
    gh.lazySingleton<_i1030.RestClient>(
      () => registerModule.authRestClient(
        gh<_i361.Dio>(),
        gh<_i431.PreferencesStorage>(),
      ),
      instanceName: 'authRestClient',
    );
    gh.lazySingleton<_i660.MenuRepository>(
        () => _i1024.MenuRepositoryImpl(gh<_i660.MenuRemoteDataSource>()));
    gh.lazySingleton<_i140.AuthRepository>(() => _i573.AuthRepositoryImpl(
          gh<_i520.AuthRemoteDataSource>(),
          gh<_i835.AuthLocalDataSource>(),
        ));
    gh.factory<_i122.RemoteConfigCubit>(() => _i122.RemoteConfigCubit(
          packageInfo: gh<_i655.PackageInfo>(),
          remoteConfig: gh<_i1020.DiyarRemoteConfig>(),
        ));
    gh.lazySingleton<_i168.AboutUsRepository>(
        () => _i471.AboutUsRepositoryImpl(gh<_i798.AboutUsRemoteDataSource>()));
    gh.factory<_i550.RefreshTokenIfNeededUseCase>(
        () => _i550.RefreshTokenIfNeededUseCase(
              gh<_i140.AuthRepository>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.lazySingleton<_i251.TemplateRemoteDataSource>(() =>
        _i692.TemplateRemoteDataSourceImpl(
            gh<_i1030.RestClient>(instanceName: 'authRestClient')));
    gh.lazySingleton<_i475.BonusRepository>(
        () => _i966.BonusRepositoryImpl(gh<_i475.BonusRemoteDataSource>()));
    gh.factory<_i36.ProfileCubit>(
        () => _i36.ProfileCubit(gh<_i315.ProfileRepository>()));
    gh.factory<_i573.AboutUsCubit>(
        () => _i573.AboutUsCubit(gh<_i168.AboutUsRepository>()));
    gh.factory<_i982.MegaInitiateUsecase>(
        () => _i982.MegaInitiateUsecase(gh<_i971.PaymentsRepository>()));
    gh.factory<_i985.MbankInitiateUsecase>(
        () => _i985.MbankInitiateUsecase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i134.MbankStatusUsecase>(
        () => _i134.MbankStatusUsecase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i299.QrCodeUsecase>(
        () => _i299.QrCodeUsecase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i283.MegaCheckUseCase>(
        () => _i283.MegaCheckUseCase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i561.MegaStatusUsecase>(
        () => _i561.MegaStatusUsecase(gh<_i971.PaymentsRepository>()));
    gh.factory<_i427.MbankConfimUsecase>(
        () => _i427.MbankConfimUsecase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i286.QrCheckStatusUsecase>(
        () => _i286.QrCheckStatusUsecase(gh<_i838.PaymentsRepository>()));
    gh.factory<_i517.CartBloc>(() => _i517.CartBloc(gh<_i26.CartRepository>()));
    gh.factory<_i31.GetNewsUseCase>(
        () => _i31.GetNewsUseCase(gh<_i477.HomeContentRepository>()));
    gh.factory<_i608.GetSalesUseCase>(
        () => _i608.GetSalesUseCase(gh<_i477.HomeContentRepository>()));
    gh.factory<_i792.SettingsCubit>(
        () => _i792.SettingsCubit(gh<_i635.SettingsRepository>()));
    gh.lazySingleton<_i54.PickUpRepositories>(
        () => _i123.PickUpRepository(gh<_i54.RemotePickUpDataSource>()));
    gh.factory<_i661.UserMapCubit>(() => _i661.UserMapCubit(
          gh<_i659.PriceRepository>(),
          gh<_i835.AppLocation>(),
        ));
    gh.lazySingleton<_i408.HistoryRepository>(
        () => _i178.HistoryRepositoryImpl(gh<_i926.HistoryReDatasource>()));
    gh.lazySingleton<_i758.OrderRepository>(
        () => _i576.OrderRepositoryImpl(gh<_i773.OrderRemoteDataSource>()));
    gh.factory<_i849.PaymentBloc>(() => _i849.PaymentBloc(
          gh<_i838.MegaCheckUseCase>(),
          gh<_i838.MegaInitiateUsecase>(),
          gh<_i838.MegaStatusUsecase>(),
          gh<_i838.QrCodeUsecase>(),
          gh<_i838.MbankInitiateUsecase>(),
          gh<_i838.MbankConfimUsecase>(),
          gh<_i838.MbankStatusUsecase>(),
        ));
    gh.lazySingleton<_i74.ActiveOrderRepository>(() =>
        _i243.ActiveOrderRepositoryImpl(
            gh<_i311.ActiveOrderRemoteDataSource>()));
    gh.factory<_i1012.PopularCubit>(
        () => _i1012.PopularCubit(gh<_i872.MenuRepository>()));
    gh.factory<_i395.MenuBloc>(
        () => _i395.MenuBloc(gh<_i872.MenuRepository>()));
    gh.factory<_i360.GenerateQrUseCase>(
        () => _i360.GenerateQrUseCase(gh<_i361.BonusRepository>()));
    gh.lazySingleton<_i566.CurierRepository>(
        () => _i537.CurierRepositoryImpl(gh<_i566.CurierDataSource>()));
    gh.factory<_i952.VerifySmsCodeAndHandleFirstLaunchUseCase>(
        () => _i952.VerifySmsCodeAndHandleFirstLaunchUseCase(
              gh<_i140.AuthRepository>(),
              gh<_i835.AuthLocalDataSource>(),
            ));
    gh.factory<_i232.HistoryCubit>(
        () => _i232.HistoryCubit(gh<_i408.HistoryRepository>()));
    gh.factory<_i781.SignUpCubit>(
        () => _i781.SignUpCubit(gh<_i140.AuthRepository>()));
    gh.factory<_i370.PickUpCubit>(
        () => _i370.PickUpCubit(gh<_i292.PickUpRepositories>()));
    gh.factory<_i110.CurierCubit>(
        () => _i110.CurierCubit(gh<_i566.CurierRepository>()));
    gh.factory<_i431.DeliveryFormCubit>(() => _i431.DeliveryFormCubit(
          gh<_i804.OrderCalculationService>(),
          gh<_i830.ValidateOrderDataUseCase>(),
        ));
    gh.factory<_i302.SignInCubit>(() => _i302.SignInCubit(
          gh<_i140.AuthRepository>(),
          gh<_i351.LocalStorage>(),
          gh<_i952.VerifySmsCodeAndHandleFirstLaunchUseCase>(),
          gh<_i550.RefreshTokenIfNeededUseCase>(),
          gh<_i35.CheckBiometricsAvailabilityUseCase>(),
          gh<_i349.AuthenticateWithBiometricsUseCase>(),
        ));
    gh.lazySingleton<_i411.TemplateRepository>(() =>
        _i843.TemplateRepositoryImpl(gh<_i251.TemplateRemoteDataSource>()));
    gh.factory<_i812.HomeContentCubit>(() => _i812.HomeContentCubit(
          getNewsUseCase: gh<_i31.GetNewsUseCase>(),
          getSalesUseCase: gh<_i608.GetSalesUseCase>(),
        ));
    gh.factory<_i60.ActiveOrderCubit>(
        () => _i60.ActiveOrderCubit(gh<_i74.ActiveOrderRepository>()));
    gh.factory<_i304.OrderCubit>(
        () => _i304.OrderCubit(gh<_i758.OrderRepository>()));
    gh.factory<_i968.BonusCubit>(
        () => _i968.BonusCubit(gh<_i135.GenerateQrUseCase>()));
    gh.factory<_i968.UpdateTemplateUseCase>(
        () => _i968.UpdateTemplateUseCase(gh<_i411.TemplateRepository>()));
    gh.factory<_i844.GetTemplateByIdUseCase>(
        () => _i844.GetTemplateByIdUseCase(gh<_i411.TemplateRepository>()));
    gh.factory<_i77.CreateTemplateUseCase>(
        () => _i77.CreateTemplateUseCase(gh<_i411.TemplateRepository>()));
    gh.factory<_i298.DeleteTemplateUseCase>(
        () => _i298.DeleteTemplateUseCase(gh<_i411.TemplateRepository>()));
    gh.factory<_i230.GetTemplatesUseCase>(
        () => _i230.GetTemplatesUseCase(gh<_i411.TemplateRepository>()));
    gh.factory<_i423.TemplatesListCubit>(() => _i423.TemplatesListCubit(
          gh<_i230.GetTemplatesUseCase>(),
          gh<_i298.DeleteTemplateUseCase>(),
          gh<_i198.PrepareDeliveryNavigationUseCase>(),
          gh<_i77.CreateTemplateUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$CartModule extends _i979.CartModule {}
