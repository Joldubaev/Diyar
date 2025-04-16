import '../../auth.dart';

abstract class SmsRepository {
  Future<void> sendSms(String code, String phone);
}

class SmsRepositoryImpl implements SmsRepository {
  final SmsRemoteDataSource remoteDataSource;

  SmsRepositoryImpl(this.remoteDataSource);
  @override
  Future<void> sendSms(String code, String phone) {
    return remoteDataSource.sendSms(code, phone);
  }
}
