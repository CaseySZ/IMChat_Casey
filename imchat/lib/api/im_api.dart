import 'package:dio/dio.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/tool/network/response_status.dart';

import '../tool/network/dio_base.dart';

class IMApi {
  static Future<String?> appInfo() async {
    try {
      Response? response = await DioBase.instance.post("/api/index", {});
      if (response?.isSuccess == true) {
        UserInfo userInfo = UserInfo.fromJson(response?.respData["memberInfo"]);
        IMConfig.userInfo = userInfo;
        IMConfig.fileServerUrl = response?.respData["fileServerUrl"];
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  static Future<String?> login(String name, String pwd) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/login",
        {"loginName": name, "password": pwd},
      );
      if(response?.isSuccess == true){
        IMConfig.token =  response?.respData;
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }
}
