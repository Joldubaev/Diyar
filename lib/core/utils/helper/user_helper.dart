import 'package:diyar/injection_container.dart';
import 'package:diyar/shared/constants/constant.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static bool isAuth() {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    return token != null && !JwtDecoder.isExpired(token);
  }
}
