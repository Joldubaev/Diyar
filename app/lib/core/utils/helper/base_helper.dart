
import '../../../injection_container.dart';
import '../../../shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseHelper {
  /// Get Dio Header
  static Map<String, dynamic> getHeaders(
      {bool isAuth = false, bool isMultipart = false}) {
    final token = getToken();
    return {
      if (isAuth && token != null) 'Authorization': 'Bearer $token',
      if (!isMultipart) 'Content-Type': 'application/json',
    }..removeWhere((key, value) => value == null);
  }

  /// Check string is email
  static bool isEmail(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
  }

  static Map<String, dynamic> authToken(String? token) {
    return token == null ? {} : {'Authorization': 'Bearer $token'};
  }

  static String? getToken() {
    return sl<SharedPreferences>().getString(AppConst.accessToken);
  }

  static String? getRefreshToken() {
    return sl<SharedPreferences>().getString(AppConst.refreshToken);
  }

  static String getZeroPaddedInt(int value) {
    return value > 9 ? "$value" : "0$value";
  }
}