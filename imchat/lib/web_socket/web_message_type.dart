

extension Resp on String {
  String get responseName {
    return replaceAll("_REQUEST", "_RESPONSE");
  }
}

class MessageType {

  static String login = "IM_CONNECT_REQUEST";
  // static String get  loginResponse {
  //   // "IM_CONNECT_RESPONSE"
  //   return loginR.replaceAll("_REQUEST", "_RESPONSE")
  // }

  static String heart = 'IM_HEARTBEAT_REQUEST';
  // 断开
  static String exit = "IM_TOKEN_EXPIRE_REQUEST";

  //打开好友对话框发送指令，否则无法收到
  static String friendBox = "IM_FRIEND_BOX_JOIN_REQUEST";

  // 好友列表
  static String friendList = "IM_FRIEND_REQUEST";

  // 消息总数返回
  static String messageTotal =  "IM_MESSAGE_TOTAL_RESPONSE";

  //聊天对象通知 聊天消息
  static String chatMessage =  "IM_CHATGARGER_RESPONSE";
}