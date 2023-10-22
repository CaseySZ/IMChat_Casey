import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static const String _nameKey = "xxx--xs1";
  static const String _pwdKey = "xxx----2";

  static Future<String?> getLoginName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_nameKey);
  }

  static Future<String?> getPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_pwdKey);
  }

  static Future<String?> removePassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(_pwdKey);
  }

  static saveUserAndPwd(String? userName, String? pwd) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (userName == null) {
      preferences.remove(_nameKey);
    } else {
      preferences.setString(_nameKey, userName);
    }
    if (pwd == null) {
      preferences.remove(_pwdKey);
    } else {
      preferences.setString(_pwdKey, pwd);
    }
  }
}

String? showDateDesc(String? time, {String char = "/"}) {
  if (time == null) return "";
  if (time.isEmpty) return "";
  var curSeconds = DateTime.now().millisecondsSinceEpoch / 1000;
  var oldSeconds = DateTime.parse(time).millisecondsSinceEpoch / 1000;
  var diff = curSeconds - oldSeconds;
  DateTime dateTime = DateTime.parse(time).toLocal();
  if (diff < 3600 * 24){
    return "${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
  }else {
    return "${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.month)}";
  }

}

String utcTurnYear(String? date, {String? char, bool? isChina}) {
  if (date == null || date.isEmpty) return '';
  String? gap = char ?? "-";
  DateTime dateTime = DateTime.parse(date).toLocal();
  String? y = _fourDigits(dateTime.year);
  String? m = _twoDigits(dateTime.month);
  String? d = _twoDigits(dateTime.day);
  if (isChina == true) {
    return "$y年$m月$d日";
  }
  return "$y$gap$m$gap$d ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
}

String? _fourDigits(int n) {
  int absN = n.abs();
  String? sign = n < 0 ? "-" : "";
  if (absN >= 1000) return "$n";
  if (absN >= 100) return "${sign}0$absN";
  if (absN >= 10) return "${sign}00$absN";
  return "${sign}000$absN";
}

String? _twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
