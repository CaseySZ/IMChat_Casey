import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {

  static const String _nameKey = "xxx--xs1";
  static const String _pwdKey = "xxx----2";
  static Future<String?>  getLoginName() async {
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return preferences.getString(_nameKey);
  }

  static Future<String?>  getPassword() async {
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return preferences.getString(_pwdKey);
  }

  static saveLoginNamePwd(String? userName, String? pwd) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    if(userName == null) {
      preferences.remove(_nameKey);
    }else {
      preferences.setString(_nameKey, userName);
    }
    if(pwd == null) {
      preferences.remove(_pwdKey);
    }else {
      preferences.setString(_pwdKey, pwd);
    }
  }

}