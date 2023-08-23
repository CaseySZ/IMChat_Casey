import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';

class WebSocketSend {

  static login() async{
    String deviceType = "2"; // 1:andoid 2:ios 3:andoid_h5 4. ios_h5 5:pc
    String deviceBrand = "";
    String deviceCode = "";
    String systemVersion = "";
    String deviceModel = "";

    DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceType = "1";
      AndroidDeviceInfo deviceInfo = await infoPlugin.androidInfo;
      deviceCode = deviceInfo.id;
      deviceBrand = deviceInfo.brand;
      systemVersion = deviceInfo.version.codename;
      deviceModel = deviceInfo.model;
    } else if (Platform.isIOS) {
      deviceType = "2";
      IosDeviceInfo deviceInfo = await infoPlugin.iosInfo;
      deviceCode = deviceInfo.identifierForVendor ?? "";
      deviceBrand = deviceInfo.systemName;
      systemVersion = deviceInfo.systemVersion;
      deviceModel = deviceInfo.model;
    }

    Map<String, dynamic> params = {
      "appVersion": IMConfig.appVersion,
      "deviceType":deviceType,
      "deviceModel": deviceModel,
      "systemVersion":systemVersion,
      "deviceCode": deviceCode,
      "deviceBrand":deviceBrand,
    };
    String jsonParams = jsonEncode(params);
    Protocol protocol = Protocol(token: IMConfig.token, cmd: MessageType.login, params: jsonParams);
    WebSocketModel.send(protocol);
  }


  static sendHeartBeat() {

    if(WebSocketModel.isConnectSocketSuccess == true) {
      Map<String, dynamic> params = {
        "token": IMConfig.token,
      };
      String jsonParams = jsonEncode(params);
      Protocol protocol = Protocol(
          token: IMConfig.token, cmd: MessageType.heart, params: jsonParams);
      WebSocketModel.send(protocol);
      Future.delayed(const Duration(seconds: 5), () {
        sendHeartBeat();
      });
    }
  }

  //打开好友对话框发送指令
  static sendOpenFriendBox(String friendNo) {

    if(WebSocketModel.isConnectSocketSuccess == true) {
      Map<String, dynamic> params = {
        "friendNo": friendNo,
      };
      String jsonParams = jsonEncode(params);
      Protocol protocol = Protocol(
          token: IMConfig.token, cmd: MessageType.friendBox, params: jsonParams);
      WebSocketModel.send(protocol);
      Future.delayed(const Duration(seconds: 5), () {
        sendHeartBeat();
      });
    }
  }

  //好友列表
  static getFriendList() {
    if(WebSocketModel.isConnectSocketSuccess == true) {
      Protocol protocol = Protocol(
          token: IMConfig.token, cmd: MessageType.friendList);
      WebSocketModel.send(protocol);
    }
  }



}