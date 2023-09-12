
class GroupMemberModel {
  int? allowSendMessage; // "允许发言(0-允许 1-不允许)")
  String? createTime;
  String? groupNo; // 是否管理员(0-是，1-否)
  String? memberHeadImage;
  String? memberNickName; // 会员昵称
  String? memberNo;
  String? memberPersonalitySign;
  String? memberStatus; // "会员状态(0正常，1拉黑)
  int? memberType; // 会员类型(0群主，1管理员，2成员)
  String? nickNameRemark; // 会员昵称备注"

  GroupMemberModel();

  GroupMemberModel.fromJson(Map<String, dynamic> json) {
    allowSendMessage = json["allowSendMessage"];
    createTime = json["createTime"];
    groupNo = json["groupNo"];
    memberHeadImage = json['memberHeadImage'];
    memberNickName = json["memberNickName"];
    memberNo =  json["memberNo"];
    memberPersonalitySign =  json["memberPersonalitySign"];
    memberStatus =  json["memberStatus"];
    memberType =  json["memberType"];
    nickNameRemark =  json["nickNameRemark"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "groupNo":groupNo,
    };
    return data;
  }
}
