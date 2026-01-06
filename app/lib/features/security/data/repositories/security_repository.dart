import 'package:diyar/features/security/domain/repository/security_repository.dart' as domain;
import 'package:diyar/features/security/data/datasources/local/security_local_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: domain.SecurityRepository)
class SecurityRepositoryImpl implements domain.SecurityRepository {
  final SecurityLocalDataSource _localDataSource;

  SecurityRepositoryImpl(this._localDataSource);

  @override
  Future<void> setPinCode(String code) {
    return _localDataSource.setPinCode(code);
  }

  @override
  Future<String?> getPinCode() {
    return _localDataSource.getPinCode();
  }
}

