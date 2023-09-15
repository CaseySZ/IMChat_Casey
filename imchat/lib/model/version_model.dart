/// 粉丝团信息
class VersionModel {
  String? content;
  String? createBy;

  String? createTime;
  String? downUrl;

  String?   id;
  String? status;
  String? type;
  String? versionCode ;
  String? updateTime;
  String? updateBy;
  VersionModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    content = json['content'];
    createBy = json['createBy'];
    createTime = json['createTime'];
    downUrl = json['downUrl'];
    id = json['  id'];

    status = json['status'];
    type = json['type'];
    versionCode = json['versionCode'];
    updateTime = json['updateTime'];
    updateBy = json['updateBy'] ;
  }

}