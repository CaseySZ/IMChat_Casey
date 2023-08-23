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
  int? sendType;
  String? chatCode;
  String? content;
  int? contentType; //0文字，1图片，2语言，3文件，4红包，5转账，6消息回撤

  int? readStatus;
  String? createTime;

  String? sendNickNameRemark;
  String? sendNickName;
  String? sendHeadImage;
  String? receiveNo;

  bool? isShowTime = false;

  ChatRecordModel();

  ChatRecordModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    sendNo = json["sendNo"];
    targetNo = json["targetNo"];
    sendType = json["sendType"];
    content = json["content"];
    chatCode = json["chatCode"];
    contentType = json["contentType"];
    readStatus = json["readStatus"];
    createTime = json["createTime"];
    sendNickNameRemark = json["sendNickNameRemark"];
    sendNickName = json["sendNickName"];
    sendHeadImage = json["sendHeadImage"];
    receiveNo = json["receiveNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}

