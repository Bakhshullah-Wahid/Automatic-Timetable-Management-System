import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferenced.dart';

class Prefs {
  static SharedPreferences? _prefs;
  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefs = await SharedPreferences.getInstance();
    // All Preferences will be initialized here
    await ThemePrefs.loginInit();
    return _prefs;
  }
}

class Prefs1 {
  static SharedPreferences? _prefs1;
  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init1() async {
    _prefs1 = await SharedPreferences.getInstance();
    // All Preferences will be initialized here
    await ThemePrefs.adminInit();
    return _prefs1;
  }
}
