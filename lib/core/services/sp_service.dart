import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/constants/constants.dart';
import 'package:todo_app/logger.dart';

const String _h = 'token_service';

class SpService {
  Future<void> setToken(String token) async {
    logInfo(_h, "cache access Token : $token");
    final pref = await SharedPreferences.getInstance();
    pref.setString(Constants.accessTokenKey, token);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(Constants.accessTokenKey);
  }
}
