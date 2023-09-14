import 'package:flutter/material.dart';
import 'package:imchat/page/chat/view/group_member_cell.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

import '../../alert/long_press_group_member.dart';
import 'model/group_member_model.dart';

class GroupMemberListPage extends StatefulWidget {
  final List<GroupMemberModel>? groupMemberArr;
  final bool isAdmin;
  final bool isAllowAddFriend;
  const GroupMemberListPage({
    super.key,
    this.groupMemberArr,
    this.isAdmin = false,
    this.isAllowAddFriend = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _GroupMemberListPageState();
  }
}

class _GroupMemberListPageState extends State<GroupMemberListPage> {
  List<GroupMemberModel> get groupMemberArr => widget.groupMemberArr ?? [];

  bool isShowMenu = false;
  GroupMemberModel? menuChatModel;
  double menuDx = 0;
  double menuDy = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "群成员"),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            itemCount: groupMemberArr.length,
            itemBuilder: (context, index) {
              GroupMemberModel model = groupMemberArr[index];
              return GroupMemberCell(
                model: model,
                callback: (dx, dy) {
                  isShowMenu = true;
                  menuChatModel = groupMemberArr![index];
                  menuDx = dx;
                  menuDy = dy;
                  setState(() {});
                },
              );
            },
          ),
          if (isShowMenu)
            LongPressGroupMember(
              dx: menuDx,
              dy: menuDy,
              model: menuChatModel,
              isAdmin: widget.isAdmin,
              isAllowAddFriend: widget.isAllowAddFriend,
              callback: (value) {
                isShowMenu = false;
                if(value == 2){
                  groupMemberArr.remove(menuChatModel);
                }
                setState(() {});
                menuChatModel = null;
              },
            ),
        ],
      )
    );
  }
}
