
class FriendApplyModel {

  String? id;
  String? memberNo;
  String? friendNo;
  int? applyStatus; // （0申请中，1同意，2拒绝）
  String? applyContent;
  String? applyTime;

  String? approvalTime;
  String? memberNickName;
  String? memberHeadImage;
  String? friendNickName;
  String? friendHeadImage;

  FriendApplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberNo = json['memberNo'];
    friendNo = json['friendNo'];
    applyStatus = json['applyStatus'];
    applyContent = json['applyContent'];
    applyTime = json['applyTime'];

    approvalTime = json['approvalTime'];
    memberNickName = json['memberNickName'];
    memberHeadImage = json['memberHeadImage'];
    friendNickName = json['friendNickName'];
    friendHeadImage = json['friendHeadImage'];
  }

}