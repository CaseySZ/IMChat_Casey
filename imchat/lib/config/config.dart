import '../model/group_item_model.dart';
import '../model/user_info.dart';

int friendApplyMessageTotal = 0;
int groupApplyMessageTotal = 0;

class IMConfig {
  static String? token;
  static int memberRegisterCodeRequiredSwitch = 1; // 邀请码必填(0-开 1-关)
  static int memberRegisterCodeSwitch = 1; // 注册邀请码(0-开 1-关)

  static String? fileServerUrl;
  static UserInfo? userInfo;
  static String appVersion = "1.0.0";
  static bool isOneKeyLogin = false; // 一键登录
}

class GlobalData {
  static List<GroupItemInfo> groupList = [];
}