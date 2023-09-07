// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/contact/my_group_page.dart';
import 'package:imchat/page/contact/new_friend_page.dart';
import 'package:imchat/page/contact/view/contact_cell_view.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/loading_alert_widget.dart';
import 'package:imchat/tool/loading/loading_center_widget.dart';
import 'package:imchat/tool/network/response_status.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/utils/toast_util.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:imchat/web_socket/web_socket_send.dart';

import '../../model/friend_item_info.dart';
import '../../tool/image/custom_new_image.dart';
import '../add_friend/add_friend_page.dart';

class GroupAddFriendPage extends StatefulWidget {
  final String groupNo;
  final bool isDelete;
  const GroupAddFriendPage({super.key, required this.groupNo, this.isDelete = false});

  @override
  State<StatefulWidget> createState() {
    return _GroupAddFriendPageState();
  }
}

class _GroupAddFriendPageState extends State<GroupAddFriendPage> {
  List<FriendItemGroupInfo>? friendList;

  List<FriendItemGroupInfo> selectItemArr = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {
    Response? response = await IMApi.groupCanAddMember(widget.groupNo);
    if (response?.isSuccess == true) {
      friendList = (response?.respData as List?)?.map((e) => FriendItemGroupInfo.fromJson(e)).toList();
    } else {
      showToast(msg: response?.tips ?? defaultErrorMsg);
    }
    if(widget.isDelete){
      friendList = friendList?.where((element) => element.isSelected == 0).toList();
      for(FriendItemGroupInfo item in (friendList ?? [])){
        item.isSelected = 1;
      }
    }else {
      friendList ??= [];
    }
    setState(() {});
  }

  void submitEvent() async {
    if (selectItemArr.isEmpty) {
      showToast(msg: "请选择成员");
      return;
    }
    LoadingAlertWidget.show(context);
    List<String> listMemberNo = selectItemArr.map((e) => e.memberNo ?? "").toList();
    var ret;
    if(widget.isDelete){
      ret = await IMApi.groupDeleteMember(widget.groupNo, listMemberNo);
    }else {
      ret = await IMApi.groupAddMember(widget.groupNo, listMemberNo);
    }
    LoadingAlertWidget.cancel(context);
    if (ret.isNotEmpty == true) {
      showToast(msg: ret);
    } else {
      showToast(msg: "添加成功");
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        leading: const SizedBox(),
        title: "群成员".localize,
        actions: [
          InkWell(
            onTap: submitEvent,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(12, 6, 16, 6),
              child:  Text(
                widget.isDelete ? "移除": "添加",
                style: const TextStyle(
                  color: Color(0xff666666),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: friendList == null
          ? const LoadingCenterWidget()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              itemCount: friendList?.length ?? 0,
              itemBuilder: (context, subIndex) {
                FriendItemGroupInfo model = friendList![subIndex];
                bool isSelect = model.isSelected == 0;
                if (selectItemArr.contains(model)) {
                  isSelect = true;
                }
                return InkWell(
                  onTap: () {
                    if (isSelect) {
                      selectItemArr.remove(model);
                    } else {
                      selectItemArr.add(model);
                    }
                    setState(() {});
                  },
                  child: Container(
                    height: 54,
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      children: [
                        CustomNewImage(
                          imageUrl: model.memberHeadImage ?? "",
                          width: 40,
                          height: 40,
                          radius: 6,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${model.memberNickName}",
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: isSelect ? null : Border.all(color: Colors.black.withOpacity(0.7)),
                            color: isSelect ? (widget.isDelete ? Colors.redAccent : Colors.blueAccent) : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
