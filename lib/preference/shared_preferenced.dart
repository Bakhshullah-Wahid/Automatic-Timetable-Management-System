import 'package:shared_preferences/shared_preferences.dart';

class ThemePrefs {
  static SharedPreferences? _loginPrefs;
  static SharedPreferences? _adminPrefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> loginInit() async {
    _loginPrefs = await SharedPreferences.getInstance();
    return _loginPrefs;
  }

  static Future<SharedPreferences?> adminInit() async {
    _adminPrefs = await SharedPreferences.getInstance();
    return _adminPrefs;
  }

  static const loginStatus = "LOGINSTATUS";
  static const adminStatus = "ADMINSTATUS";

  static Future<bool?> setLogin(bool value) async =>
      await _loginPrefs?.setBool('LOGINSTATUS', value);
  static bool getLogin() => _loginPrefs?.getBool(loginStatus) ?? false;

  static Future<bool?> setIsAdmin(bool value) async =>
      await _adminPrefs?.setBool('ADMINSTATUS', value);
  static bool getIsAdmin() => _adminPrefs?.getBool(adminStatus) ?? false;
}
