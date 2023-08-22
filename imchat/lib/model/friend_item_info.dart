import 'package:imchat/tool/network/dio_base.dart';

/// 粉丝团信息
///




class FriendGroupInfo{
  List<FriendItemInfo>? listFriend;
  String? nickNameFirstLetter;
  FriendGroupInfo.fromJson(Map<String, dynamic>? json) {
    nickNameFirstLetter = json?['nickNameFirstLetter'];
    listFriend = (json?["listFriend"] as List?)?.map((e) => FriendItemInfo.fromJson(e)).toList() ?? [];
  }
}


class FriendItemInfo {

  static List<FriendGroupInfo>? myList;
  static void parse(dynamic data){
    try {
      List<FriendGroupInfo> groupInfo = [];
      if (data is List && data.first is Map) {
        for(int i = 0; i < data.length; i++){
          FriendGroupInfo info =  FriendGroupInfo.fromJson(data[i]);
          groupInfo.add(info);
        }
      }
      myList = groupInfo;
    }catch(e){
      debugLog("FriendItemInfo parse error: $e");
    }
  }

  String? friendNo;
  String? headImage;
  int? loginStatus; // 0 在线， 1 离线
  String? nickName;
  String? nickNamePinyin;
  String? nickNameFirstLetter;
  bool get onLine => loginStatus == 0;

  int? contentType;
  int? isTop;
  String? lastContent;
  int? messageNum;
  String? personalitySign;
  String? targetNo;
  int? targetType;

  FriendItemInfo.fromJson(Map<String, dynamic> json) {
    friendNo = json['friendNo'];
    headImage = json['headImage'];
    loginStatus = json['loginStatus'];
    nickName = json['nickName'];
    nickNamePinyin = json['nickNamePinyin'];
    nickNameFirstLetter = json['nickNameFirstLetter'];

    contentType = json['contentType'];
    isTop = json['isTop'];
    lastContent = json['lastContent'];
    messageNum = json['messageNum'];
    personalitySign = json['personalitySign'];
    targetNo = json['targetNo'];
    targetType = json['targetType'];
  }

}