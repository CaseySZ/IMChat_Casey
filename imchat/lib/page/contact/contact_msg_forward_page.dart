import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/page/contact/view/contact_cell_view.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';

import '../../api/im_api.dart';
import '../../config/config.dart';
import '../../model/collect_model.dart';
import '../../model/friend_item_info.dart';
import '../../model/group_item_model.dart';
import '../../tool/image/custom_new_image.dart';
import '../../tool/network/response_status.dart';
import '../../utils/toast_util.dart';

class ContactMsgForwardPage extends StatefulWidget {
  final CollectModel? model;

  const ContactMsgForwardPage({
    super.key,
    this.model,
  });

  @override
  State<StatefulWidget> createState() {
    return _ContactMsgForwardPageState();
  }
}

class _ContactMsgForwardPageState extends State<ContactMsgForwardPage> {
  List<FriendGroupInfo> get friendList => FriendItemInfo.myList ?? [];

  List<GroupItemInfo> get groupArr => GlobalData.groupList;

  PageController controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  void sendMsgToFriend(FriendItemInfo friendInfo) async {
    Navigator.pop(context);
    var errorDesc = await IMApi.sendMsg(friendInfo.friendNo ?? "", widget.model?.imagePath ?? "", 1);
    if (errorDesc?.isNotEmpty == true) {
      showToast(msg: errorDesc ?? defaultErrorMsg);
    } else {
      showToast(msg: "转发成功");
    }
  }

  void sendMsgToGroup(GroupItemInfo friendInfo) async {
    Navigator.pop(context);
    var errorDesc = await IMApi.sendGroupMsg(friendInfo.groupNo ?? "", widget.model?.imagePath ?? "", 1);
    if (errorDesc?.isNotEmpty == true) {
      showToast(msg: errorDesc ?? defaultErrorMsg);
    } else {
      showToast(msg: "转发成功");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "消息转发"),
      body: Column(
        children: [
          _buildMenuView(),
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                _buildFriendList(),
                _buildGroupList(),
              ],
              onPageChanged: (value) {
                currentPage = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuView() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              currentPage = 0;
              setState(() {});
              controller.jumpToPage(0);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                "好友",
                style: TextStyle(
                  color: (currentPage == 0) ? Colors.black : const  Color(0xff999999),
                  fontSize: 16,
                  fontWeight: (currentPage == 0) ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              currentPage = 0;
              setState(() {});
              controller.jumpToPage(1);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                "群组",
                style: TextStyle(
                  color: (currentPage == 1) ? Colors.black : const Color(0xff999999),
                  fontSize: 16,
                  fontWeight: (currentPage == 1) ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupList() {
    if (groupArr.isEmpty) {
      return EmptyErrorWidget(
        retryOnTap: () {
          setState(() {});
        },
      );
    }
    return ListView.builder(
      itemCount: groupArr.length,
      itemBuilder: (context, index) {
        return _buildGroupItem(
          groupArr[index],
        );
      },
    );
  }

  Widget _buildFriendList() {
    if (friendList.isEmpty) {
      return EmptyErrorWidget(
        retryOnTap: () {
          setState(() {});
        },
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4),
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        FriendGroupInfo groupInfo = friendList[index];
        return Column(
          children: [
            Container(
              height: 24,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                groupInfo.nickNameFirstLetter ?? "",
                style: const TextStyle(fontSize: 16, color: Color(0xff666666)),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: groupInfo.listFriend?.length ?? 0,
              itemBuilder: (context, subIndex) {
                FriendItemInfo model = groupInfo.listFriend![subIndex];
                return ContactCellView(
                  model: model,
                  callback: () {
                    sendMsgToFriend(model);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupItem(GroupItemInfo model) {
    return InkWell(
      onTap: () async {
        sendMsgToGroup(model);
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 16),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            CustomNewImage(
              imageUrl: model.headImage,
              width: 42,
              height: 42,
              radius: 6,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xfff1f1f1)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name ?? "",
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "公告：${model.personalitySign ?? ""}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xff666666),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
