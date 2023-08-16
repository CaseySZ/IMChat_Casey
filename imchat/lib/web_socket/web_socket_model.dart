import 'package:imchat/tool/network/dio_base.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketModel {

  static IOWebSocketChannel? channel; //= IOWebSocketChannel.connect('ws://8.217.117.185:9090');
  static init() async {
    channel =  IOWebSocketChannel.connect('ws://8.217.117.185:9090');
    channel?.stream.listen((message) {
      debugLog("webSocket:$message");
      parseMessage(message);
    });
  }

  static parseMessage(dynamic message){

  }

  static send(dynamic message){
    channel?.sink.add(message);
  }

  static close() {
    channel?.sink.close(status.goingAway);
  }

}