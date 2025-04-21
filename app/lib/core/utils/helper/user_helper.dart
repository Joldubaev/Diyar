import 'package:diyar/core/core.dart';
import 'package:diyar/injection_container.dart';

class UserHelper {
  static bool isAuth() {
    var token = sl<LocalStorage>().getString(AppConst.accessToken);
    return token != null;
  }
}
