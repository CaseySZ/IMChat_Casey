class ChatRecordResponse {
  List<ChatRecordModel>? data;
  int? total;
  int? pageNum;
  int? pageSize;
  ChatRecordResponse({this.data, this.total, this.pageSize, this.pageNum,});

  ChatRecordResponse.fromJson(Map<String, dynamic>? json) {
    if(json == null){
      return;
    }
    if(json["data"] is List) {
      data = (json["data"] as List).map((e) => ChatRecordModel.fromJson(e)).toList();
    }
    total = json["total"];
    pageNum = json["pageNum"];
    pageSize = json["pageSize"];
  }

}

class ChatRecordModel {
  String? id;
  String? sendNo;
  String? targetNo;
  int? targetType; // 0好友，1 群
  int? sendType;
  String? chatCode;
  String? content;
  String get chatContent {
    if (content?.isNotEmpty == true) {
      int length = content?.length ?? 0;
      if (content!.substring(length - 1, length) == "\n") {
        return content!.substring(0, length - 1);
      }
      return content ?? "";
    }
    return "";
  }
  String? localImgPath;
  int? contentType; //0文字，1图片，2语言，3文件，4红包，5转账，6消息回撤

  int? readStatus; // 0 未读， 1 已读
  String? createTime;

  String? sendNickNameRemark;
  String? sendNickName;
  String? sendHeadImage;
  String? receiveNo;
  String? nickName;
  int? isTop;
  bool? isShowTime = false;
  int? messageNum;
  String? personalitySign;
  int? sendStatus; // 0 发送中， 1发送失败, 其他正常
  String? lastContent;
  ChatRecordModel();

  ChatRecordModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    sendNo = json["sendNo"];
    targetNo = json["targetNo"];
    nickName = json['nickName'];
    targetType = json['targetType'];
    sendType = json["sendType"];
    content = json["content"];
    if(json["lastContent"] != null){
      content = json["lastContent"];
      lastContent = json["lastContent"];
    }
    chatCode = json["chatCode"];
    contentType = json["contentType"];
    readStatus = json["readStatus"];
    createTime = json["createTime"];
    sendNickNameRemark = json["sendNickNameRemark"];
    sendNickName = json["sendNickName"];
    sendHeadImage = json["sendHeadImage"];
    if(json["headImage"] != null){
      sendHeadImage = json["headImage"];
    }
    receiveNo = json["receiveNo"];
    isTop = json["isTop"];
    messageNum = json["messageNum"];
    personalitySign = json["personalitySign"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}

