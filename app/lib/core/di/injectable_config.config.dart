// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:geo/geo.dart' as _i736;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:network/network.dart' as _i372;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:rest_client/rest_client.dart' as _i1030;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:storage/storage.dart' as _i431;

import '../../features/about_us/data/data.dart' as _i798;
import '../../features/about_us/data/remote_datasource/about_us_remote_datasource.dart'
    as _i243;
import '../../features/about_us/data/repository/repository.dart' as _i471;
import '../../features/about_us/domain/domain.dart' as _i168;
import '../../features/about_us/presentation/cubit/about_us_cubit.dart'
    as _i573;
import '../../features/active_order/data/data.dart' as _i311;
import '../../features/active_order/data/datasource/active_order_remote_data_source.dart'
    as _i887;
import '../../features/active_order/data/repository/active_order_repository.dart'
    as _i243;
import '../../features/active_order/data/services/order_status_service.dart'
    as _i697;
import '../../features/active_order/domain/domain.dart' as _i74;
import '../../features/active_order/presentation/cubit/active_order_cubit.dart'
    as _i60;
import '../../features/app/cubit/remote_config_cubit.dart' as _i122;
import '../../features/app_init/domain/usecases/check_authentication_status_usecase.dart'
    as _i141;
import '../../features/app_init/domain/usecases/get_navigation_route_usecase.dart'
    as _i212;
import '../../features/app_init/domain/usecases/handle_first_launch_usecase.dart'
    as _i449;
import '../../features/app_init/presentation/cubit/splash_cubit.dart' as _i858;
import '../../features/auth/data/datasources/local/auth_local_data_source.dart'
    as _i835;
import '../../features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i520;
import '../../features/auth/data/datasources/remote/auth_remote_datasource_impl.dart'
    as _i415;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/domain/domain.dart' as _i140;
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
import '../../features/bonus/presentation/cubit/bonus_cubit.dart' as _i968;
import '../../features/cart/data/cart_module.dart' as _i979;
import '../../features/cart/data/datasources/cart_local_data_source.dart'
    as _i706;
import '../../features/cart/domain/domain.dart' as _i885;
import '../../features/cart/domain/repository/cart_repository.dart' as _i26;
import '../../features/cart/domain/services/order_calculation_service.dart'
    as _i1043;
import '../../features/cart/presentation/bloc/cart_bloc.dart' as _i517;
import '../../features/cart/presentation/cubit/cart_cutlery_cubit.dart'
    as _i512;
import '../../features/cart/presentation/cubit/cart_price_cubit.dart' as _i132;
import '../../features/curier/curier.dart' as _i566;
import '../../features/curier/data/datasource/curier_data_source.dart' as _i614;
import '../../features/curier/data/datasource/curier_payment_data_source.dart'
    as _i485;
import '../../features/curier/data/repositories/curier_payment_repository.dart'
    as _i225;
import '../../features/curier/data/repositories/curier_repository.dart'
    as _i537;
import '../../features/curier/data/services/courier_location_hub_service.dart'
    as _i689;
import '../../features/curier/domain/domain.dart' as _i949;
import '../../features/curier/domain/repository/curier_payment_repository.dart'
    as _i533;
import '../../features/curier/domain/usecases/confirm_cash_payment_and_finish_usecase.dart'
    as _i340;
import '../../features/curier/presentation/cubit/curier_cubit.dart' as _i110;
import '../../features/history/data/data.dart' as _i368;
import '../../features/history/data/data_source/history_re_datasource.dart'
    as _i49;
import '../../features/history/data/repositories/history_repositories.dart'
    as _i178;
import '../../features/history/domain/domain.dart' as _i408;
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
import '../../features/map/domain/domain.dart' as _i883;
import '../../features/map/presentation/cubit/address_selection_cubit.dart'
    as _i159;
import '../../features/map/presentation/cubit/user_map_cubit.dart' as _i661;
import '../../features/menu/data/datasources/remote_datasource/menu_remote_data_sources.dart'
    as _i433;
import '../../features/menu/data/repositories/menu_repository.dart' as _i1024;
import '../../features/menu/domain/domain.dart' as _i872;
import '../../features/menu/menu.dart' as _i660;
import '../../features/menu/presentation/cubit/menu_category_cubit.dart'
    as _i266;
import '../../features/menu/presentation/cubit/menu_products_cubit.dart'
    as _i202;
import '../../features/menu/presentation/cubit/search_cubit.dart' as _i182;
import '../../features/ordering/delivery/data/datasources/order_remote_datasource.dart'
    as _i755;
import '../../features/ordering/delivery/data/datasources/order_remote_datasource_impl.dart'
    as _i1001;
import '../../features/ordering/delivery/data/repository/order_repository.dart'
    as _i1010;
import '../../features/ordering/delivery/domain/repositories/order_repositories.dart'
    as _i701;
import '../../features/ordering/delivery/domain/usecases/order_usecase.dart'
    as _i635;
import '../../features/ordering/delivery/presentation/cubit/delivery_form_cubit.dart'
    as _i316;
import '../../features/ordering/detail/data/datasource/order_detail_remote_data_source.dart'
    as _i831;
import '../../features/ordering/detail/data/repository/order_detail_repository.dart'
    as _i778;
import '../../features/ordering/detail/domain/domain.dart' as _i913;
import '../../features/ordering/detail/presentation/cubit/order_detail_cubit.dart'
    as _i500;
import '../../features/ordering/pickup/data/datasource/remote_pick_up_datasource.dart'
    as _i192;
import '../../features/ordering/pickup/data/repository/pick_up_repository.dart'
    as _i493;
import '../../features/ordering/pickup/domain/domain.dart' as _i809;
import '../../features/ordering/pickup/domain/usecases/calculate_minimum_time_usecase.dart'
    as _i101;
import '../../features/ordering/pickup/domain/usecases/create_pickup_order_from_cart_usecase.dart'
    as _i987;
import '../../features/ordering/pickup/domain/usecases/validate_bonus_usecase.dart'
    as _i818;
import '../../features/ordering/pickup/pick_up.dart' as _i1066;
import '../../features/ordering/pickup/presentation/cubit/pick_up_cubit.dart'
    as _i859;
import '../../features/templates/data/datasources/template_remote_data_source.dart'
    as _i251;
import '../../features/templates/data/datasources/template_remote_datasource_impl.dart'
    as _i692;
import '../../features/templates/data/repository/template_repository.dart'
    as _i843;
import '../../features/templates/domain/repository/template_repository.dart'
    as _i411;
import '../../features/templates/domain/usecases/prepare_delivery_navigation_usecase.dart'
    as _i198;
import '../../features/templates/presentation/cubit/templates_list_cubit.dart'
    as _i423;
import '../../features/user/profile/data/datasources/profile_remote_data_source.dart'
    as _i424;
import '../../features/user/profile/data/repositories/profile_repository.dart'
    as _i618;
import '../../features/user/profile/presentation/cubit/profile_cubit.dart'
    as _i830;
import '../../features/user/profile/profile.dart' as _i526;
import '../../features/user/security/data/services/secure_storage_service_impl.dart'
    as _i420;
import '../../features/user/security/domain/services/secure_storage_service.dart'
    as _i895;
import '../../features/user/settings/data/datasource/remote_settings_datasource.dart'
    as _i507;
import '../../features/user/settings/data/repository/settings_repository.dart'
    as _i615;
import '../../features/user/settings/domain/domain.dart' as _i728;
import '../../features/user/settings/domain/repositories/settings_repositories.dart'
    as _i20;
import '../../features/user/settings/presentation/cubit/settings_cubit.dart'
    as _i424;
import '../../features/web_payment/data/datasource/open_banking_remote_datasource.dart'
    as _i456;
import '../../features/web_payment/data/repository/open_banking_repository_impl.dart'
    as _i889;
import '../../features/web_payment/data/services/payment_status_signalr_service_impl.dart'
    as _i981;
import '../../features/web_payment/domain/domain.dart' as _i204;
import '../../features/web_payment/domain/repository/i_open_banking_repository.dart'
    as _i354;
import '../../features/web_payment/domain/services/i_payment_status_signalr_service.dart'
    as _i848;
import '../../features/web_payment/presentation/cubit/open_banking_cubit.dart'
    as _i789;
import '../core.dart' as _i351;
import '../remote_config/diyar_remote_config.dart' as _i1020;
import '../services/map_service.dart' as _i569;
import '../shared/presentation/bloc/internet_bloc.dart' as _i231;
import '../shared/presentation/theme_cubit/theme_cubit.dart' as _i489;
import '../utils/storage/address_storage_service.dart' as _i478;
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
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i569.MapService>(() => _i569.MapService());
    gh.factory<_i101.CalculateMinimumTimeUseCase>(
        () => _i101.CalculateMinimumTimeUseCase());
    gh.factory<_i818.ValidateBonusUseCase>(() => _i818.ValidateBonusUseCase());
    gh.factory<_i987.CreatePickupOrderFromCartUseCase>(
        () => _i987.CreatePickupOrderFromCartUseCase());
    gh.factory<_i512.CartCutleryCubit>(() => _i512.CartCutleryCubit());
    gh.singleton<_i231.InternetBloc>(() => _i231.InternetBloc());
    gh.lazySingleton<_i431.SecureStorage>(() => registerModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i161.InternetConnection>(
        () => registerModule.internetConnection);
    gh.lazySingleton<_i431.PreferencesStorage>(
        () => registerModule.preferencesStorage);
    gh.lazySingleton<_i736.ZoneRepository>(() => registerModule.zoneRepository);
    gh.lazySingleton<_i1043.OrderCalculationService>(
        () => _i1043.OrderCalculationService());
    await gh.factoryAsync<_i31.LocalStorage>(
      () => registerModule.localStorage(gh<_i460.SharedPreferences>()),
      preResolve: true,
    );
    gh.lazySingleton<_i706.CartLocalDataSource>(
        () => _i706.CartHiveDataSource());
    gh.lazySingleton<_i424.ProfileRemoteDataSource>(
        () => _i424.ProfileRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.factory<_i489.ThemeCubit>(
        () => _i489.ThemeCubit(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i689.CourierLocationHubService>(
        () => _i689.CourierLocationHubService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i697.OrderStatusService>(
        () => _i697.OrderStatusService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i526.ProfileRepository>(
        () => _i618.ProfileRepositoryImpl(gh<_i526.ProfileRemoteDataSource>()));
    gh.lazySingleton<_i372.TokenStorage>(
        () => registerModule.tokenStorage(gh<_i431.PreferencesStorage>()));
    gh.lazySingleton<_i755.OrderRemoteDataSource>(
        () => _i1001.OrderRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i831.OrderDetailRemoteDataSource>(
        () => _i831.OrderDetailRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i887.ActiveOrderRemoteDataSource>(
        () => _i887.ActiveOrderRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i243.AboutUsRemoteDataSource>(
        () => _i243.AboutUsRemoteDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.factory<_i830.ProfileCubit>(
        () => _i830.ProfileCubit(gh<_i526.ProfileRepository>()));
    gh.lazySingleton<_i507.RemoteSettingsDataSource>(
        () => _i507.RemoteSettingsDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i337.RemoteDataSource>(
        () => _i337.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i1030.RestClient>(
      () => registerModule.unauthRestClient(gh<_i361.Dio>()),
      instanceName: 'unauthRestClient',
    );
    gh.factory<_i859.PickUpCubit>(() => _i859.PickUpCubit(
          gh<_i809.PickUpRepository>(),
          gh<_i809.CreatePickupOrderFromCartUseCase>(),
          gh<_i809.CalculateMinimumTimeUseCase>(),
          gh<_i809.ValidateBonusUseCase>(),
        ));
    gh.lazySingleton<_i521.HomeContentRemoteDatasource>(
        () => _i347.HomeContentRemoteDatasourceImpl(gh<_i361.Dio>()));
    gh.factory<_i848.IPaymentStatusSignalRService>(
        () => _i981.PaymentStatusSignalRServiceImpl());
    gh.factory<_i132.CartPriceCubit>(() => _i132.CartPriceCubit(
          gh<_i1043.OrderCalculationService>(),
          initialItems: gh<List<_i885.CartItemEntity>>(),
        ));
    gh.lazySingleton<_i456.OpenBankingRemoteDatasource>(
        () => _i456.OpenBankingRemoteDatasource(gh<_i361.Dio>()));
    gh.lazySingleton<_i701.OrderRepository>(
        () => _i1010.OrderRepositoryImpl(gh<_i755.OrderRemoteDataSource>()));
    gh.lazySingleton<_i805.BonusRemoteDataSource>(
        () => _i805.BonusRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i433.MenuRemoteDataSource>(
        () => _i433.MenuRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i354.IOpenBankingRepository>(() =>
        _i889.OpenBankingRepositoryImpl(
            gh<_i456.OpenBankingRemoteDatasource>()));
    await gh.factoryAsync<_i1020.DiyarRemoteConfig>(
      () => registerModule.diyarRemoteConfig(gh<_i655.PackageInfo>()),
      preResolve: true,
    );
    gh.lazySingleton<_i485.CurierPaymentDataSource>(
        () => _i485.CurierPaymentDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i835.AuthLocalDataSource>(
        () => _i835.AuthLocalDataSourceImpl(
              gh<_i351.LocalStorage>(),
              gh<_i431.SecureStorage>(),
            ));
    gh.lazySingleton<_i478.AddressStorageService>(
        () => registerModule.addressStorageService(gh<_i31.LocalStorage>()));
    gh.lazySingleton<_i533.CurierPaymentRepository>(() =>
        _i225.CurierPaymentRepositoryImpl(gh<_i485.CurierPaymentDataSource>()));
    gh.lazySingleton<_i728.SettingsRepository>(() =>
        _i615.SettingsRepositoryImpl(gh<_i507.RemoteSettingsDataSource>()));
    gh.lazySingleton<_i614.CurierDataSource>(() => _i614.CurierDataSourceImpl(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i477.HomeContentRepository>(() =>
        _i347.HomeContentRepositoryImpl(
            remoteDataSource: gh<_i521.HomeContentRemoteDatasource>()));
    gh.lazySingleton<_i883.PriceRepository>(
        () => _i659.PriceRepositoryImpl(gh<_i337.RemoteDataSource>()));
    gh.lazySingleton<_i192.RemotePickUpDataSource>(
        () => _i192.RemotePickUpDataSourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    await gh.factoryAsync<_i26.CartRepository>(
      () => cartModule.cartRepository(gh<_i706.CartLocalDataSource>()),
      preResolve: true,
    );
    gh.factory<_i198.PrepareDeliveryNavigationUseCase>(() =>
        _i198.PrepareDeliveryNavigationUseCase(
            gh<_i1043.OrderCalculationService>()));
    gh.lazySingleton<_i49.HistoryReDatasource>(
        () => _i49.HistoryReDatasourceImpl(
              gh<_i361.Dio>(),
              gh<_i460.SharedPreferences>(),
            ));
    gh.lazySingleton<_i835.AppLocation>(() => _i835.LocationService(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i1030.RestClient>(
      () => registerModule.authRestClient(
        gh<_i361.Dio>(),
        gh<_i431.PreferencesStorage>(),
      ),
      instanceName: 'authRestClient',
    );
    gh.lazySingleton<_i660.MenuRepository>(
        () => _i1024.MenuRepositoryImpl(gh<_i660.MenuRemoteDataSource>()));
    gh.factory<_i424.SettingsCubit>(
        () => _i424.SettingsCubit(gh<_i20.SettingsRepository>()));
    gh.lazySingleton<_i913.OrderDetailRepository>(() =>
        _i778.OrderDetailRepositoryImpl(
            gh<_i831.OrderDetailRemoteDataSource>()));
    gh.factory<_i661.UserMapCubit>(() => _i661.UserMapCubit(
          gh<_i883.PriceRepository>(),
          gh<_i835.AppLocation>(),
        ));
    gh.lazySingleton<_i74.ActiveOrderRepository>(() =>
        _i243.ActiveOrderRepositoryImpl(
            gh<_i311.ActiveOrderRemoteDataSource>()));
    gh.factory<_i122.RemoteConfigCubit>(() => _i122.RemoteConfigCubit(
          packageInfo: gh<_i655.PackageInfo>(),
          remoteConfig: gh<_i1020.DiyarRemoteConfig>(),
        ));
    gh.lazySingleton<_i168.AboutUsRepository>(
        () => _i471.AboutUsRepositoryImpl(gh<_i798.AboutUsRemoteDataSource>()));
    gh.lazySingleton<_i635.CreateOrderUseCase>(
        () => _i635.CreateOrderUseCase(gh<_i701.OrderRepository>()));
    gh.factory<_i266.MenuCategoryCubit>(
        () => _i266.MenuCategoryCubit(gh<_i872.MenuRepository>()));
    gh.factory<_i182.MenuSearchCubit>(
        () => _i182.MenuSearchCubit(gh<_i872.MenuRepository>()));
    gh.factory<_i202.MenuProductsCubit>(
        () => _i202.MenuProductsCubit(gh<_i872.MenuRepository>()));
    gh.lazySingleton<_i251.TemplateRemoteDataSource>(() =>
        _i692.TemplateRemoteDataSourceImpl(
            gh<_i1030.RestClient>(instanceName: 'authRestClient')));
    gh.lazySingleton<_i475.BonusRepository>(
        () => _i966.BonusRepositoryImpl(gh<_i475.BonusRemoteDataSource>()));
    gh.factory<_i573.AboutUsCubit>(
        () => _i573.AboutUsCubit(gh<_i168.AboutUsRepository>()));
    gh.factory<_i517.CartBloc>(() => _i517.CartBloc(
          gh<_i26.CartRepository>(),
          gh<_i1043.OrderCalculationService>(),
        ));
    gh.lazySingleton<_i809.PickUpRepositories>(
        () => _i493.PickUpRepository(gh<_i1066.RemotePickUpDataSource>()));
    gh.factory<_i159.AddressSelectionCubit>(() => _i159.AddressSelectionCubit(
          gh<_i883.PriceRepository>(),
          gh<_i478.AddressStorageService>(),
          gh<_i835.AppLocation>(),
        ));
    gh.factory<_i789.OpenBankingCubit>(() => _i789.OpenBankingCubit(
          gh<_i204.IOpenBankingRepository>(),
          gh<_i204.IPaymentStatusSignalRService>(),
        ));
    gh.lazySingleton<_i520.AuthRemoteDataSource>(
        () => _i415.AuthRemoteDataSourceImpl(
              gh<_i1030.RestClient>(instanceName: 'unauthRestClient'),
              gh<_i835.AuthLocalDataSource>(),
              gh<_i351.LocalStorage>(),
            ));
    gh.factory<_i31.GetNewsUseCase>(
        () => _i31.GetNewsUseCase(gh<_i477.HomeContentRepository>()));
    gh.factory<_i608.GetSalesUseCase>(
        () => _i608.GetSalesUseCase(gh<_i477.HomeContentRepository>()));
    gh.lazySingleton<_i895.SecureStorageService>(
        () => _i420.SecureStorageServiceImpl(
              gh<_i835.AuthLocalDataSource>(),
              gh<_i351.LocalStorage>(),
              gh<_i431.SecureStorage>(),
            ));
    gh.lazySingleton<_i140.AuthRepository>(() => _i573.AuthRepositoryImpl(
          gh<_i520.AuthRemoteDataSource>(),
          gh<_i835.AuthLocalDataSource>(),
        ));
    gh.factory<_i812.HomeContentCubit>(() => _i812.HomeContentCubit(
          getNewsUseCase: gh<_i31.GetNewsUseCase>(),
          getSalesUseCase: gh<_i608.GetSalesUseCase>(),
          menuRepository: gh<_i872.MenuRepository>(),
          activeOrderRepository: gh<_i74.ActiveOrderRepository>(),
          profileRepository: gh<_i526.ProfileRepository>(),
        ));
    gh.lazySingleton<_i408.HistoryRepository>(
        () => _i178.HistoryRepositoryImpl(gh<_i368.HistoryReDatasource>()));
    gh.factory<_i500.OrderDetailCubit>(
        () => _i500.OrderDetailCubit(gh<_i913.OrderDetailRepository>()));
    gh.lazySingleton<_i566.CurierRepository>(
        () => _i537.CurierRepositoryImpl(gh<_i566.CurierDataSource>()));
    gh.factory<_i968.BonusCubit>(
        () => _i968.BonusCubit(gh<_i135.BonusRepository>()));
    gh.factory<_i781.SignUpCubit>(
        () => _i781.SignUpCubit(gh<_i140.AuthRepository>()));
    gh.factory<_i952.VerifySmsCodeAndHandleFirstLaunchUseCase>(
        () => _i952.VerifySmsCodeAndHandleFirstLaunchUseCase(
              gh<_i140.AuthRepository>(),
              gh<_i835.AuthLocalDataSource>(),
            ));
    gh.factory<_i316.DeliveryFormCubit>(() => _i316.DeliveryFormCubit(
          gh<_i1043.OrderCalculationService>(),
          gh<_i635.CreateOrderUseCase>(),
        ));
    gh.factory<_i232.HistoryCubit>(
        () => _i232.HistoryCubit(gh<_i408.HistoryRepository>()));
    gh.lazySingleton<_i60.ActiveOrderCubit>(() => _i60.ActiveOrderCubit(
          gh<_i74.ActiveOrderRepository>(),
          gh<_i697.OrderStatusService>(),
        ));
    gh.factory<_i550.RefreshTokenIfNeededUseCase>(
        () => _i550.RefreshTokenIfNeededUseCase(
              gh<_i140.AuthRepository>(),
              gh<_i431.SecureStorage>(),
            ));
    gh.factory<_i340.ConfirmCashPaymentAndFinishUseCase>(
        () => _i340.ConfirmCashPaymentAndFinishUseCase(
              gh<_i949.CurierPaymentRepository>(),
              gh<_i949.CurierRepository>(),
            ));
    gh.factory<_i449.HandleFirstLaunchUseCase>(
        () => _i449.HandleFirstLaunchUseCase(gh<_i895.SecureStorageService>()));
    gh.factory<_i141.CheckAuthenticationStatusUseCase>(() =>
        _i141.CheckAuthenticationStatusUseCase(
            gh<_i895.SecureStorageService>()));
    gh.factory<_i212.GetNavigationRouteUseCase>(() =>
        _i212.GetNavigationRouteUseCase(gh<_i895.SecureStorageService>()));
    gh.lazySingleton<_i411.TemplateRepository>(() =>
        _i843.TemplateRepositoryImpl(gh<_i251.TemplateRemoteDataSource>()));
    gh.factory<_i423.TemplatesListCubit>(() => _i423.TemplatesListCubit(
          gh<_i411.TemplateRepository>(),
          gh<_i198.PrepareDeliveryNavigationUseCase>(),
        ));
    gh.factory<_i302.SignInCubit>(() => _i302.SignInCubit(
          gh<_i140.AuthRepository>(),
          gh<_i952.VerifySmsCodeAndHandleFirstLaunchUseCase>(),
          gh<_i550.RefreshTokenIfNeededUseCase>(),
        ));
    gh.factory<_i110.CurierCubit>(() => _i110.CurierCubit(
          gh<_i566.CurierRepository>(),
          gh<_i566.ConfirmCashPaymentAndFinishUseCase>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.factory<_i858.SplashCubit>(() => _i858.SplashCubit(
          gh<_i141.CheckAuthenticationStatusUseCase>(),
          gh<_i550.RefreshTokenIfNeededUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$CartModule extends _i979.CartModule {}
