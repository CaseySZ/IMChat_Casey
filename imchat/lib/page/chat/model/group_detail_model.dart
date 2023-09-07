

class GroupDetailModel {
  String? groupNo;
  String? headImage;
  int? isAdmin; // 是否管理员(0-是，1-否)
  String? name;
  String? personalitySign;
  GroupAuthModel? groupAuth;
  GroupDetailModel();

  GroupDetailModel.fromJson(Map<String, dynamic> json) {
    groupNo = json["groupNo"];
    headImage = json["headImage"];
    isAdmin = json["isAdmin"];
    name = json['name'];
    personalitySign = json["personalitySign"];
    groupAuth = GroupAuthModel.fromJson(json["groupAuth"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}

class GroupAuthModel {
  int? allowAllSendMessage; // 允许全体发言（0允许，1禁止）
  int? allowGroupMemberAdd; // 允许添加好友（0允许，1禁止）
  int? allowGroupMemberExit; // 允许成员退群（0允许，1禁止）
  String? groupNo;
  int? showGroupMemberList; // 显示群全成员（0是，1否）
  GroupAuthModel();

  GroupAuthModel.fromJson(Map<String, dynamic> json) {
    groupNo = json["groupNo"];
    allowAllSendMessage = json["allowAllSendMessage"];
    allowGroupMemberAdd = json["allowGroupMemberAdd"];
    allowGroupMemberExit = json["allowGroupMemberExit"];
    showGroupMemberList = json["showGroupMemberList"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    return data;
  }
}
