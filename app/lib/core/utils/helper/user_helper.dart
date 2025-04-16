import '../../../injection_container.dart';
import '../../../shared/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  static bool isAuth() {
    var token = sl<SharedPreferences>().getString(AppConst.accessToken);
    return token != null;
  }
}
