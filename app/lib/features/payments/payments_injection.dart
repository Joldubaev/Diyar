import 'package:diyar/features/payments/payments.dart';
import 'package:diyar/injection_container.dart';


paymentsInjection() {
  // DATA SOURCES
  sl.registerLazySingleton<RemotePaymentsDatasource>(() => RemotePaymentsDatasourceImpl(sl()));
  // REPOSITORIES
  sl.registerSingleton<PaymentsRepository>(PaymentsRepositoryImpl(sl()));

  // USE CASES
  sl.registerLazySingleton(() => MegaCheckUseCase(sl()));
  sl.registerLazySingleton(() => MegaInitiateUsecase(sl()));
  sl.registerLazySingleton(() => MegaStatusUsecase(sl()));
  sl.registerLazySingleton(() => QrCodeUsecase(sl()));
  sl.registerLazySingleton(() => MbankInitiateUsecase(sl()));
  sl.registerLazySingleton(() => MbankConfimUsecase(sl()));
  sl.registerLazySingleton(() => MbankStatusUsecase(sl()));
  // BLOC
  sl.registerLazySingleton(() => PaymentBloc(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
}
