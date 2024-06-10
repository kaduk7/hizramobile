import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;
  
  static const _keyIsLoggedIn = 'isLoggedIn';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setLoginStatus(bool isLoggedIn) async {
    await _preferences.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  static bool getLoginStatus() {
    return _preferences.getBool(_keyIsLoggedIn) ?? false;  // Provide a default value of 'false'
  }
}

