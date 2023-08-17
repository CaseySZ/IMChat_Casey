import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
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
    Protocol protocol = Protocol(token: IMConfig.token, cmd: "IM_CONNECT_REQUEST", params: jsonParams);
    WebSocketModel.send(protocol);
  }


}