import 'package:shared_preferences/shared_preferences.dart';


class SharedPreference {
  saveProfileSharedPreference({String email, String uid}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('uid', uid);
  }

  saveAvatarUrl(String avatarUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatarUrl', avatarUrl);
  }

  getAvatarUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String avatarUrl = prefs.get('avatarUrl');
    return avatarUrl;
  }

  clearSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  isUserLogin() async {
    var isLogin = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    if (uid != null) {
      isLogin=true;
    }
    return isLogin;
  }
}
