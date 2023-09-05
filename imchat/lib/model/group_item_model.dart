
class GroupItemInfo {

  String? groupNo;
  String? headImage;
  String? name; //
  String? personalitySign;


  GroupItemInfo.fromJson(Map<String, dynamic> json) {
    groupNo = json['groupNo'];
    headImage = json['headImage'];
    name = json['name'];
    personalitySign = json['personalitySign'];
  }

}