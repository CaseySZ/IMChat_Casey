// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/screen.dart';
import '../page/chat/model/group_member_model.dart';
import '../utils/toast_util.dart';

class LongPressGroupMember extends StatelessWidget {
  final double dx;
  final double dy;
  final Function(int)? callback;
  final GroupMemberModel? model;
  final bool isAllowAddFriend;
  final bool isAdmin;
  List<IconData> get iconArr => [
        Icons.copy,
        Icons.keyboard_return_rounded,
        Icons.keyboard_return_rounded,
        Icons.delete_outline,
      ];

  const LongPressGroupMember({
    super.key,
    required this.dx,
    required this.dy,
    this.model,
    this.callback,
    this.isAdmin = false,
    this.isAllowAddFriend = false,
  });

  double get height {
    if(isAdmin) {
      return 40 * 3 + (showAllowAddFriend ? 40 : 0);
    }else if(showAllowAddFriend){
      return 40;
    }else {
      return 0;
    }
  }

  bool get isShowAdmin {
    return model?.memberType != 2;
  }

  bool get isAllowSendMsg {
    return model?.allowSendMessage == 0;
  }

  double get realDy {
    double reY = dy - screen.paddingTop - kToolbarHeight;
    if (reY > height) {
      reY -= height;
    }
    return reY;
  }

  double get realDx {
    double reY = dx - 100;
    if (reY < 50) {
      reY = dx;
    }
    return reY;
  }

  bool get showAllowAddFriend{
    return isAllowAddFriend &&  model?.memberNo != IMConfig.userInfo?.memberNo;
  }
  Future _setAdmin(BuildContext context) async {
    LoadingAlertWidget.show(context);
    String? errorStr = await IMApi.groupSetAdmin(model?.groupNo ?? "", isShowAdmin ? 1 : 0, model?.memberNo ?? "");
    LoadingAlertWidget.cancel(context);
    if (errorStr?.isEmpty == true) {
      showToast(msg: "设置成功".localize);
      model?.memberType = isShowAdmin ? 2 : 1;
    } else {
      showToast(msg: errorStr ?? defaultErrorMsg);
    }
  }

  Future _setAllowSendMsg(BuildContext context) async {
    LoadingAlertWidget.show(context);
    String? errorStr = await IMApi.groupForbidMemberMsg(
      model?.groupNo ?? "",
      model?.memberNo ?? "",
      isAllowSendMsg ? 1 : 0,
    );
    LoadingAlertWidget.cancel(context);
    if (errorStr?.isEmpty == true) {
      showToast(msg: isAllowSendMsg ? "已禁言".localize : "已解除禁言".localize);
      model?.allowSendMessage = isAllowSendMsg ? 1 : 0;
    } else {
      showToast(msg: errorStr ?? defaultErrorMsg);
    }
  }

  Future _removeMember(BuildContext context) async {
    LoadingAlertWidget.show(context);
    String? errorStr = await IMApi.groupDeleteMember(model?.groupNo ?? "", [model?.memberNo ?? ""]);
    LoadingAlertWidget.cancel(context);
    if (errorStr?.isEmpty == true) {
      showToast(msg: "已踢出群".localize);
    } else {
      showToast(msg: errorStr ?? defaultErrorMsg);
    }
  }

  Future _addFriendMember(BuildContext context) async {
    LoadingAlertWidget.show(context);
    Response? response = await IMApi.addFriend(model?.memberNo ?? "", "");
    LoadingAlertWidget.cancel(context);
    if(response?.isSuccess != true){
      showToast(msg: response?.tips ?? defaultErrorMsg);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback?.call(-1);
        },
        child: Stack(
          children: [
            Positioned(
              left: realDx,
              top: realDy,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: height,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 3.0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(isAdmin)...[
                        _buildItem(context, 0, isShowAdmin ? "取消管理员".localize : "设为管理员".localize, ""),
                        _buildItem(context, 1, isAllowSendMsg ? "禁言".localize : "取消禁言".localize, ""),
                        _buildItem(context, 2, "踢出群".localize, ""),
                      ],
                      if(showAllowAddFriend)
                        _buildItem(context, 3, "添加好友".localize, ""),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, String title, String imagePath) {
    return InkWell(
      onTap: () async {
        if (index == 0) {
          await _setAdmin(context);
        } else if (index == 1) {
          await _setAllowSendMsg(context);
        } else if (index == 2){
          await _removeMember(context);
        }else {
          await _addFriendMember(context);
        }
        callback?.call(index);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff111111),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
