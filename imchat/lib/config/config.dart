import '../model/group_item_model.dart';
import '../model/user_info.dart';

int friendApplyMessageTotal = 0;
int groupApplyMessageTotal = 0;

class IMConfig {
  static String? token;

  static String? fileServerUrl;
  static UserInfo? userInfo;
  static String appVersion = "1.0.0";
  static bool isOneKeyLogin = false; // 一键登录
  static bool isBackground = false;
}

class GlobalData {
  static List<GroupItemInfo> groupList = [];
}