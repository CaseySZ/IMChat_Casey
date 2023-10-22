import '../../../tool/network/dio_base.dart';

class ChatRecordResponse {
  List<ChatRecordModel>? data;
  int? total;
  int? pageNum;
  int? pageSize;

  ChatRecordResponse({
    this.data,
    this.total,
    this.pageSize,
    this.pageNum,
  });

  ChatRecordResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    if (json["data"] is List) {
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
  String? groupNo;

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

  String? localPath;
  int? contentType; //0文字，1图片，2语音，3文件，4红包，5转账，6消息回撤
  String get contentTypeDesc {
    if (contentType == 1) {
      return "图片";
    }
    if (contentType == 2) {
      return "2语音";
    }
    if (contentType == 3) {
      return "文件";
    }
    return "";
  }

  int? readStatus; // 0 未读， 1 已读
  String? createTime;
  String? contentTime;
  String? get showNickName {
    return sendNickNameRemark ?? nickName;
  }

  String? sendNickNameRemark;
  String? sendNickName;
  String? sendHeadImage;
  String? receiveNo;
  String? nickName;
  int? isTop;
  bool? isShowTime = false;
  int? messageNum;
  String? personalitySign;
  int? sendStatus; // 0 发送中， 1发送失败,  -1 移除消息， 其他正常
  String? lastContent;
  List<RichTitle>? richTitleArr;
  String? relationId;
  RelationChatRecord? relationChatRecord;
  
  ChatRecordModel();

  void parserChatTitle() {
    String originTitle = chatContent;
    List<String> linkArr = originTitle.split("[/");
    richTitleArr = [];
    try {
      if (linkArr.length == 1) {
        richTitleArr!.add(RichTitle(originTitle, false));
      } else {
        richTitleArr!.add(RichTitle(linkArr.first, false));
        for (int i = 1; i < linkArr.length; i++) {
          String nextStr = linkArr[i];
          if (nextStr.contains("]")) {
            List<String> subLinkArr = nextStr.split("]");
            String emoStr = "[/${subLinkArr.first}]";
            richTitleArr!.add(RichTitle(emoStr, true));
            richTitleArr!.add(RichTitle(subLinkArr.last, false));
          } else {
            richTitleArr!.last.content = "${richTitleArr!.last.content}[/$nextStr";
          }
        }
      }
    } catch (e) {
      richTitleArr!.clear();
      richTitleArr!.add(RichTitle(originTitle, false));
      debugLog("解析错误：$e");
    }
  }

  ChatRecordModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    relationId = json["relationId"];
    sendNo = json["sendNo"];
    groupNo = json['groupNo'];
    targetNo = json["targetNo"];
    nickName = json['nickName'];
    targetType = json['targetType'];
    sendType = json["sendType"];
    content = json["content"];
    if (json["lastContent"] != null) {
      content = json["lastContent"];
      lastContent = json["lastContent"];
    }
    chatCode = json["chatCode"];
    contentType = json["contentType"];
    readStatus = json["readStatus"];
    createTime = json["createTime"];
    contentTime = json["contentTime"];
    sendNickNameRemark = json["sendNickNameRemark"];
    sendNickName = json["sendNickName"];
    sendHeadImage = json["sendHeadImage"];
    if (json["headImage"] != null) {
      sendHeadImage = json["headImage"];
    }
    receiveNo = json["receiveNo"];
    isTop = json["isTop"];
    messageNum = json["messageNum"];
    personalitySign = json["personalitySign"];
    if (contentType == 0) {
      parserChatTitle();
    }
    if(json["relationChatRecord"] is Map){
      relationChatRecord = RelationChatRecord.fromJson(json["relationChatRecord"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}

class RelationChatRecord{
  String? chatCode;
  String? content;
  int? contentType;
  String? createTime;
  String? id;
  int? readStatus;
  String? receiveNo;
  String? relationId;
  String? sendHeadImage;
  String? sendNickName;
  String? sendNo;
  int? sendType;
  RelationChatRecord? relationChatRecord;

  RelationChatRecord.fromJson(Map<String, dynamic> json) {
    chatCode = json["chatCode"];
    content = json["content"];
    contentType = json["contentType"];
    createTime = json["createTime"];
    id = json["id"];
    readStatus = json["readStatus"];
    receiveNo = json["receiveNo"];
    relationId = json["relationId"];
    sendHeadImage = json["sendHeadImage"];
    sendNickName = json["sendNickName"];
    sendNo = json["sendNo"];
    sendType = json["sendType"];
    if(json["relationChatRecord"] is Map){
      relationChatRecord = RelationChatRecord.fromJson(json["relationChatRecord"]);
    }
  }
}

class RichTitle {
  String content = "";
  bool isImg = false;

  RichTitle(this.content, this.isImg);
}
