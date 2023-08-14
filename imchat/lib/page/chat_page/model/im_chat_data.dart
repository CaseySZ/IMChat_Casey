class IMChatResponse {
  List<IMChatItemData>? chats;
  bool? hasNext;

  IMChatResponse({this.chats, this.hasNext,});

  IMChatResponse.fromJson(Map<String, dynamic>? json) {
    if(json == null){
      return;
    }
    if(json["chats"] is List) {
      chats = (json["chats"] as List).map((e) => IMChatItemData.fromJson(e)).toList();
    }
    hasNext = json["hasNext"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["chats"] = chats;
    data['hasNext'] = hasNext;

    return data;
  }
}

class IMChatItemData {
  String? id;
  String? groupId;
  int? uid;
  String? content;
  String? imgContent;
  bool? isDelete;
  String? createdAt;
  String? createAtDesc;
  String? updatedAt;
  String? avatar;
  int? age;
  String? nickName;
  int? gender;
  bool? isShowTime;
  IMChatItemData();

  IMChatItemData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    groupId = json["groupId"];
    uid = json["uid"];
    content = json["content"];
    imgContent = json["imgContent"];
    isDelete = json["isDelete"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    avatar = json["avatar"];
    age = json["age"];
    nickName = json["nickName"];
    gender = json["gender"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}

