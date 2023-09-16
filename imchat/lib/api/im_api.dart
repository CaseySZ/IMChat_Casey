import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:imchat/api/group_auth_info.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/web_socket/web_socket_send.dart';
import '../page/chat/model/group_detail_model.dart';
import '../tool/network/dio_base.dart';
import '../web_socket/web_socket_model.dart';

class IMApi {
  static Future<String?> appInfo() async {
    try {
      Response? response = await DioBase.instance.post("/api/index", {});
      if (response?.isSuccess == true) {
        UserInfo userInfo = UserInfo.fromJson(response?.respData["memberInfo"]);
        IMConfig.userInfo = userInfo;
        IMConfig.fileServerUrl = response?.respData["fileServerUrl"];
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
    return null;
  }

  static Future<String?> login(String name, String pwd) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/login",
        {"loginName": name, "password": pwd},
      );
      if (response?.isSuccess == true) {
        WebSocketModel.init();
        IMConfig.token = response?.respData;
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
    return null;
  }

  // 一键登录
  static Future<String?> autoLogin() async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/autoRegisterLogin", {},
      );
      if (response?.isSuccess == true) {
        WebSocketModel.init();
        IMConfig.token = response?.respData;
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
    return null;
  }

  static Future<String?> logout() async {
    try {
      Response? response = await DioBase.instance.post("/api/logout", {});
      if (response?.isSuccess == true) {
        IMConfig.token = "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
    return null;
  }

  // 添加好友
  static Future<Response?> addFriend(String friendNo, String applyContent) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/friendApply/add",
        {"friendNo": friendNo, "applyContent": applyContent},
      );
      return response;
    } catch (e) {
      debugLog(e);
      return null;
    }
    return null;
  }

  //好友申请添加审批 （0申请中，1同意，2拒绝)
  static Future<Response?> addFriendAgree(int applyStatus, String id) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/friendApply/approval",
        {"applyStatus": applyStatus, "id": id},
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  //获取好友申请 我的分页
  static Future<Response?> getAddMyFriendList() async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/friendApply/friendApplyPage",
        {
          "imFriendAddApplyPageReqDto": true,
        },
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  //获取我申请的好友分页
  static Future<Response?> getMyAddFriendList() async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/friendApply/myApplyPage",
        {
          "imFriendAddApplyPageReqDto": true,
        },
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(requestOptions: RequestOptions(), statusCode: 404, statusMessage: e.toString());
    }
  }

  // (contentType 0文字，1图片，2语音，3文件)
  static Future<String?> sendMsg(String friendNo, String content, int contentType) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/memberChatRecord/send",
        {"friendNo": friendNo, "content": content, "contentType": contentType},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  static Future<Response?> getChatHistory(String friendNo, {String? startChatRecordId}) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/memberChatRecord/page",
        {
          "friendNo": friendNo,
          "startChatRecordId": startChatRecordId ?? "",
        },
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  //聊天对象置顶是否
  static Future<String?> chatMsgIsTop(int isTop, String? targetNo, int targetType) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/charTarget/isTop",
        {
          "isTop": isTop, // 置顶(0-否，1-是)
          "targetNo": targetNo, // 对象号码
          "targetType": targetType, // 对象类型(0好友，1群)
        },
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }

    } catch (e) {
      debugLog(e);
      return defaultErrorMsg;
    }
  }

  // 群创建
  static Future<String?> groupCreate(String headImage, String name, String personalitySign) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/add",
        {"headImage": headImage, "name": name, "personalitySign": personalitySign},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // 群编辑
  static Future<String?> groupEdit({
    String? groupNo,
    String? headImage,
    String? name,
    String? personalitySign,
    GroupAuthModel? authInfo,
  }) async {
    try {
      Map<String, dynamic> groupAuth = {
        "allowAllSendMessage": authInfo?.allowAllSendMessage,
        "allowGroupMemberAdd": authInfo?.allowGroupMemberAdd,
        "allowGroupMemberExit": authInfo?.allowGroupMemberExit,
        "showGroupMemberList": authInfo?.showGroupMemberList,
      };
      groupAuth.removeWhere((k, v) => v == null);
      Map<String, dynamic> param = {
        'groupNo': groupNo,
        "headImage": headImage,
        "name": name,
        "personalitySign": personalitySign,
        "groupAuth": groupAuth.isNotEmpty ? groupAuth : null,
      };
      param.removeWhere((k, v) => v == null);
      Response? response = await DioBase.instance.post(
        "/api/group/edit",
        param,
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // 获取群信息
  static Future<Response?> groupInfo(String groupNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/find",
        {
          "groupNo": groupNo,
        },
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  // 群成员新增
  static Future<String> groupAddMember(String groupNo, List<String> listMemberNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/member/edit",//"/api/group/find",
        {"groupNo": groupNo, "listMemberNo": listMemberNo},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips ?? defaultErrorMsg;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // 群成员禁言 allowSendMessage 0-允许 1-不允许
  static Future<String?> groupForbidMemberMsg(String groupNo, String memberNo, int allowSendMessage) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/member/allowSendMessage",
        {
          "groupNo": groupNo,
          "memberNo": memberNo,
          "allowSendMessage": allowSendMessage,
        },
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //获取群可添加会员列表
  static Future<Response?> groupCanAddMember(String groupNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/member/list",
        {"groupNo": groupNo},
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  // 群成员删除
  static Future<String?> groupDeleteMember(String groupNo, List<String> listMemberNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/member/remove",
        {
          "groupNo": groupNo,
          "listMemberNo": listMemberNo,
        },
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // 群成员设置管理员 isAdmin 设置管理员(0-是 1-否)
  static Future<String?> groupSetAdmin(String groupNo, int isAdmin, String memberNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/member/setGroupAdmin",
        {
          "groupNo": groupNo,
          "isAdmin": isAdmin,
          "memberNo": memberNo,
        },
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //解散或退出群
  static Future<String?> groupRemove(String groupNo) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/group/remove",
        {"groupNo": groupNo},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //群聊天记录分页
  static Future<Response?> groupChatHistory(String groupNo, String? startChatRecordId) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/groupChatRecord/page",
        {"groupNo": groupNo, "startChatRecordId": startChatRecordId ?? ""},
      );
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  //群发送消息回撤
  static Future<String?> groupDeleteMsg(
    String groupNo,
    String groupChatRecordId,
  ) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/groupChatRecord/remove",
        {"groupChatRecordId": groupChatRecordId},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //向群发送信息
  static Future<String?> sendGroupMsg(String groupNo, String content, int contentType) async {
    try {
      Response? response = await DioBase.instance.post(
        "/api/groupChatRecord/send",
        {"content": content, "groupNo": groupNo, "contentType": contentType},
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //会员信息设置
  static Future<String?> userInfoSet({
    String? headImage,
    String? nickName,
    String? password,
    String? personalitySign,
    int? sex,
  }) async {
    try {
      Map<String, dynamic> param = {
        "headImage": headImage,
        "nickName": nickName,
        "password": password,
        "personalitySign": personalitySign,
        "sex": sex,
      };
      param.removeWhere((key, value) => value == null);
      Response? response = await DioBase.instance.post(
        "/api/member/edit",
        param,
      );
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  //会员个人信息
  static Future<Response?> getUserInfo() async {
    try {
      Response? response = await DioBase.instance.post("/api/member/info", {});
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  // 搜索 会员分页
  static Future<Response?> searchUser(String searchContent) async {
    try {
      Response? response = await DioBase.instance.post("/api/member/page", {"searchContent": searchContent});
      return response;
    } catch (e) {
      debugLog(e);
      return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: e.toString(),
      );
    }
  }

  // 删除消息
  static Future<String?> chatMsgDelete(String memberChatRecordId) async {
    try {
      Response? response = await DioBase.instance.post("/api/memberChatRecord/remove", {"memberChatRecordId": memberChatRecordId});
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  // 好友昵称备注
  static Future<String?> setFriendNickName(String friendNo, String nickNameRemark) async {
    try {
      Response? response =
          await DioBase.instance.post("/api/memberFriend/friendRemark", {"friendNo": friendNo, "nickNameRemark": nickNameRemark});
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return e.toString();
    }
  }

  static Future<Response?> getAppVersion({bool isIos = false}) async {
    try {
      Response? response =
      await DioBase.instance.post(isIos ? "/api/findNowVersion/ios" : "/api/findNowVersion/android", {});
      return response;
    } catch (e) {
      debugLog(e);
      return null;
    }
  }

  //chatRecordType (0_好友聊天,1_群聊天)
  static Future<String?> collectAdd({String? chatRecordId, int? chatRecordType}) async {
    try {
      Response? response =
      await DioBase.instance.post("/api/memberImageCollect/add", {
        "chatRecordId": chatRecordId,
        "chatRecordType": chatRecordType,
      },);
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return null;
    }
  }

  static Future<String?> collectDelete({List<String>? listId}) async {
    try {
      Response? response =
      await DioBase.instance.post("/api/memberImageCollect/remove", {
        "listId": listId,
      },);
      if (response?.isSuccess == true) {
        return "";
      } else {
        return response?.tips;
      }
    } catch (e) {
      debugLog(e);
      return null;
    }
  }

  static Future<Response?> getCollect() async {
    try {
      Response? response =
      await DioBase.instance.post("/api/memberImageCollect/list", {},);
      return response;
    } catch (e) {
      debugLog(e);
      return null;
    }
  }
}
