import 'package:diyar/core/core.dart';
import 'package:injectable/injectable.dart';

/// Data source для локального хранения данных безопасности (PIN)
abstract class SecurityLocalDataSource {
  Future<String?> getPinCode();
  Future<void> setPinCode(String pinCode);
}

@LazySingleton(as: SecurityLocalDataSource)
class SecurityLocalDataSourceImpl implements SecurityLocalDataSource {
  final LocalStorage prefs;

  SecurityLocalDataSourceImpl(this.prefs);

  @override
  Future<String?> getPinCode() async {
    try {
      return prefs.getString(AppConst.pinCode);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> setPinCode(String pinCode) async {
    try {
      await prefs.setString(AppConst.pinCode, pinCode);
    } catch (e) {
      throw CacheException();
    }
  }
}
