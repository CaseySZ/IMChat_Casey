/// 粉丝团信息
class CollectModel {
  String? id;
  String? imagePath;

  String? imageUrl;
  String? memberNo;

  CollectModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    id = json['id'];
    imagePath = json['imagePath'];
    imageUrl = json['imageUrl'];
    memberNo = json['memberNo'];
  }

}