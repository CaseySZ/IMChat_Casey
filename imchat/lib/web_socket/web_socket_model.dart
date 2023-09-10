import 'dart:convert';
import 'package:imchat/model/friend_item_info.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_send.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../protobuf/model/base.pb.dart';

extension JsonProto on Protocol {
  Map<String, dynamic> get mapInfo {
    try {
      Map<String, dynamic> model = jsonDecode(response);
      return model;
    }catch(e) {
      debugLog("websockect json decode fail: $e");
      return {};
    }
  }

  bool get  isSuccess  {
    return mapInfo["code"] == "200";
  }

  List? get dataArr {
    if(mapInfo["data"] is List){
      return mapInfo["data"];
    }
    return null;
  }

  Map<String, dynamic>? get dataMap {
    if(mapInfo["data"] is Map){
      return mapInfo["data"];
    }
    return null;
  }

  String? get code {
    return mapInfo["code"];
  }

  dynamic get data {
    return mapInfo["data"];
  }

}

class WebSocketModel {
  static bool? isConnectSocketSuccess;
  static final List<Function(Protocol protocol)> _listernArr = [];

  static void addListener(Function(Protocol protocol) item) {
    _listernArr.add(item);
  }

  static void removeListener(Function(Protocol protocol) item) {
    _listernArr.remove(item);
  }

  static void removeAll() {
    _listernArr.clear();
  }

  static void notifyListeners(Protocol protocol) {
    for (var item in _listernArr) {
      item(protocol);
    }
  }

  static IOWebSocketChannel? channel; //= IOWebSocketChannel.connect('ws://8.217.117.185:9090');
  static init() async {
    channel =  IOWebSocketChannel.connect('ws://8.217.117.185:9090');
    channel?.stream.listen((message) {
      Protocol protocol = Protocol.fromBuffer(message);
      _parseMessage(protocol);
    });
  }

  static retryConnect() {
    channel =  IOWebSocketChannel.connect('ws://8.217.117.185:9090');
    channel?.stream.listen((message) {
      Protocol protocol = Protocol.fromBuffer(message);
      _parseMessage(protocol);
    });
  }

  static _parseMessage(Protocol protocol){
    if(protocol.cmd == MessageType.heart.responseName){

    }else {
      debugLog("webSocket:${protocol.cmd}, code: ${protocol.code}, data: ${protocol.data}");
    }
    if(protocol.cmd == MessageType.login.responseName){
      if(protocol.isSuccess){
        WebSocketModel.isConnectSocketSuccess = true;
        WebSocketSend.sendHeartBeat();
      }else {
        WebSocketModel.isConnectSocketSuccess = false;
      }
    }

    if(protocol.cmd == MessageType.friendList.responseName){
      if(protocol.isSuccess) {
        FriendItemInfo.parse(protocol.data);
      }
    }

    if(protocol.cmd == MessageType.exit.responseName){
      WebSocketModel.isConnectSocketSuccess = false;
     // retryConnect();
    }
    notifyListeners(protocol);
  }

  static send(Protocol protocol){
    channel?.sink.add(protocol.writeToBuffer());
  }

  static close() {
    channel?.sink.close(status.goingAway);
  }

}

