/// 粉丝团信息
class UserInfo {
  String? loginName;
  String? memberNo;
  int? status;
  int? isAdmin;
  String? nickName;
  String? nickNamePinyin;

  int? sex;
  String? headImage;
  String? personalitySign;
  String? ip = '';
  String? ipLocation;

  UserInfo.fromJson(Map<String, dynamic> json) {
    loginName = json['loginName'];
    memberNo = json['memberNo'];
    status = json['status'];
    isAdmin = json['isAdmin'];
    nickName = json['nickName'];

    nickNamePinyin = json['nickNamePinyin'];
    sex = json['sex'];
    headImage = json['headImage'];
    personalitySign = json['personalitySign'];
    ip = json['ip'] ?? '';
    ipLocation = json['ipLocation'];
  }

}