import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/dio_base.dart';
import 'package:imchat/utils/toast_util.dart';

import '../../../api/group_auth_info.dart';
import '../../../model/friend_item_info.dart';
import '../model/group_detail_model.dart';

class GroupSettingItem extends StatefulWidget {
  final GroupDetailModel? groupModel;
  final FriendItemInfo? model;
  final String? title;
  final Function? callback;
  const GroupSettingItem({super.key, this.title, this.groupModel, this.model, this.callback,});

  @override
  State<StatefulWidget> createState() {
    return _GroupSettingItemState();
  }
}

class _GroupSettingItemState extends State<GroupSettingItem> {
  GroupDetailModel? get groupModel => widget.groupModel;

  String get title => widget.title ?? "";

  bool get switchValue {
    if(title == "聊天置顶".localize && widget.model != null){
      return widget.model?.isTop == 1;
    }
    if (title == "允许全体发言".localize) {
      return groupModel?.groupAuth?.allowAllSendMessage == 0;
    } else if (title == "允许添加好友".localize) {
      return groupModel?.groupAuth?.allowGroupMemberAdd == 0;
    } else if (title == "允许成员退群".localize) {
      return groupModel?.groupAuth?.allowGroupMemberExit == 0;
    } else if (title == "显示群全成员".localize) {
      return groupModel?.groupAuth?.showGroupMemberList == 0;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  void _loadData(bool value) async {

    if (_isLoading) return;
    _isLoading = true;

    if (title == "允许全体发言".localize) {
      groupModel?.groupAuth?.allowAllSendMessage = value ? 0 : 1;
    } else if (title == "允许添加好友".localize) {
      groupModel?.groupAuth?.allowGroupMemberAdd = value ? 0 : 1;
    } else if (title == "允许成员退群".localize) {
      groupModel?.groupAuth?.allowGroupMemberExit = value ? 0 : 1;
    } else if (title == "显示群全成员".localize) {
      groupModel?.groupAuth?.showGroupMemberList = value ? 0 : 1;
    } else if(title == "聊天置顶".localize){
      widget.model?.isTop = value ? 1 : 0;
    }else {}

    setState(() {});
    String? retStr;
    if(title == "聊天置顶".localize){
      retStr = await IMApi.chatMsgIsTop(
          value ? 1 : 0,
          groupModel?.groupNo ?? widget.model?.friendNo,
          (groupModel != null) ? 1 : 0
      );
    }else {
      retStr = await IMApi.groupEdit(
        groupNo: groupModel?.groupNo,
        name: groupModel?.name,
        personalitySign: groupModel?.personalitySign,
        authInfo: groupModel?.groupAuth,
      );
    }
    if (retStr?.isNotEmpty == true) {
      if (title == "允许全体发言".localize) {
        groupModel?.groupAuth?.allowAllSendMessage = value ? 1 : 0;
      } else if (title == "允许添加好友".localize) {
        groupModel?.groupAuth?.allowGroupMemberAdd = value ? 1 : 0;
      } else if (title == "允许成员退群".localize) {
        groupModel?.groupAuth?.allowGroupMemberExit = value ? 1 : 0;
      } else if (title == "显示群全成员".localize) {
        groupModel?.groupAuth?.showGroupMemberList = value ? 1 : 0;
      }else if(title == "聊天置顶".localize){
        widget.model?.isTop = value ? 0 : 1;
      }else {

      }
      showToast(msg: retStr!);
    } else {
      widget.callback?.call();
    }
    _isLoading = false;
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xfff1f1f1)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          if (_isLoading)
            Container(
              padding: const EdgeInsets.only(right: 2),
              child: const CupertinoActivityIndicator(
                color: Colors.black,
                radius: 10,
              ),
            ),
          Switch(
            value: switchValue,
            onChanged: _loadData,
          ),
        ],
      ),
    );
  }
}
