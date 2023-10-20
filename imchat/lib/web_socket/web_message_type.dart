

extension Resp on String {
  String get responseName {
    return replaceAll("_REQUEST", "_RESPONSE");
  }
}

class MessageType {

  static String login = "IM_CONNECT_REQUEST";

  static String heart = 'IM_HEARTBEAT_REQUEST';

  // 链接断开通知，需要重连
  static String exit = "IM_TOKEN_EXPIRE_REQUEST";

  //打开好友对话框发送指令，否则无法收到
  static String friendBox = "IM_FRIEND_BOX_JOIN_REQUEST";

  //关闭好友对话框发送指令
  static String closeFriendBox = "IM_FRIEND_BOX_LEAVE_REQUEST";

  // 编辑打字状态通知好友
  static String editText = "IM_FRIEND_BOX_WRITE_START_REQUEST";

  // 停止打字状态通知好友
  static String stopEditText = "IM_FRIEND_BOX_WRITE_END_REQUEST";


  // 消息总数返回
  static String messageTotal =  "IM_MESSAGE_TOTAL_RESPONSE";


  //打开群对话框发送指令，否则无法收到
  static String groupBox = "IM_GROUP_BOX_JOIN_REQUEST";

  //关闭群对话框发送指令
  static String closeGroupBox = "IM_GROUP_BOX_LEAVE_REQUEST";

  //会员退出群发送指令
  static String exitGroup = "IM_MEMBER_EXIT_GROUP_REQUEST";

  //好友信息推送
  static String friendChatMessage = "IM_FRIEND_INFO_REQUEST";

  //聊天对象 消息通知
  static String chatBoxMessage = "IM_CHATGARGER_REQUEST";

  //好友聊天记录返回(包括自己的消息也返回，历史记录叠加)
  static String chatHistory =  "IM_FRIENDCHATMESSAGE_REQUEST";

  //好友聊天记录消息撤销通知
  static String chatRemove =  "IM_FRIENDCHATMESSAGE_REMOVE_REQUEST";

  // 好友列表
  static String friendList = "IM_FRIEND_REQUEST";

  //群列表推送
  static String groupList =  "IM_GROUP_REQUEST";

  // 群成员列表推送
  static String groupMember =  "IM_GROUPMEMBER_RESPONSE";


  // 群聊天记录返回(包括自己的消息也返回，历史记录叠加)
  static String chatGroupHistory =  "IM_GROUPCHATMESSAGE_REQUEST";

  //群踢会员返回
  static String groupRemoveMember =  "IM_GROUP_REMOVE_MEMBER_RESPONSE";

  //群解散通知返回
  static String groupDelete =  "IM_GROUP_REMOVE_RESPONSE";

  //群聊天记录消息撤销通知
  static String groupMessageDelete =  "IM_GROUPCHATMESSAGE_REMOVE_RESPONSE";

  //会员聊天记录清空
  static String friendMsgClear =  "IM_FRIENDCHATMESSAGE_CLEAR_RESPONSE";

  //群聊天记录清空
  static String groupMsgClear =  "IM_GROUPCHATMESSAGE_CLEAR_RESPONSE";

}