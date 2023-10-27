import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/utils/screen.dart';

import '../model/group_member_model.dart';
import 'group_member_cell.dart';

class MemberListAlert extends StatelessWidget {
  static show(BuildContext context, List<GroupMemberModel>? modelArr, {Function(GroupMemberModel?)? callback}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: screen.screenHeight * 0.7,
          child: MemberListAlert(
            modelArr: modelArr,
            callback: callback,
          ),
        );
      },
    );
  }

  final List<GroupMemberModel>? modelArr;
  final Function(GroupMemberModel?)? callback;

  const MemberListAlert({
    super.key,
    this.modelArr,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: modelArr?.length ?? 0,
        itemBuilder: (context, index) {
          GroupMemberModel model = modelArr![index];
          return InkWell(
            onTap: () {
              callback?.call(model);
              Navigator.pop(context);
            },
            child: GroupMemberCell(
              model: model,
            ),
          );
        },
      ),
    );
  }
}
