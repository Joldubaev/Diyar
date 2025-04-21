import 'package:diyar/core/network/dio_network.dart';
import 'package:diyar/features/about_us/domain/domain.dart';
import 'package:diyar/injection_container.dart';

import 'data/remote_datasource/about_us_remote_datasource.dart';
import 'data/repository/repository.dart';
import 'presentation/cubit/about_us_cubit.dart';

aboutUsInjection() {
  sl.registerSingleton<AboutUsRemoteDataSource>(AboutUsRemoteDataSourceImpl(DioNetwork.appAPI, sl()));

sl.registerSingleton<AboutUsRepository>(AboutUsRepositoryImpl(sl()));


  // BLOC
  sl.registerFactory(() => AboutUsCubit(sl()));
}
