import 'package:dio/dio.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/web_socket/web_socket_send.dart';
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
        WebSocketSend.login();
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  static Future<String?> logout(String name, String pwd) async {
    try {
      Response? response = await DioBase.instance.post("/api/logout", {});
      if(response?.isSuccess == true){
        IMConfig.token = "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  static Future<String?>  addFriend(String friendNo, String applyContent) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/friendApply/add",
        {"friendNo": friendNo, "applyContent": applyContent},
      );
      if(response?.isSuccess == true){

      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // (contentType 0文字，1图片，2语言，3文件)
  static Future<String?> sendMsg(String friendNo, String content, int contentType) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/memberChatRecord/send",
        {"friendNo": friendNo, "content": content, "contentType": contentType},
      );
      if(response?.isSuccess == true){
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

}
