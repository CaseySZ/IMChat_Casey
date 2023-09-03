import 'package:flutter/material.dart';
import 'package:imchat/page/contact/view/contact_cell_view.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:imchat/web_socket/web_socket_send.dart';

import '../../model/friend_item_info.dart';

class ContactMainPage extends StatefulWidget {
  const ContactMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContactMainPageState();
  }
}

class _ContactMainPageState extends State<ContactMainPage> with AutomaticKeepAliveClientMixin {
  List<FriendGroupInfo>? get friendList => FriendItemInfo.myList;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WebSocketModel.addListener(messageListen);
  }

  void messageListen(Protocol data) {
    if (data.cmd == MessageType.friendList) {
      FriendItemInfo.parse(data.data);
      setState(() {});
    }
  }

  void sendFriendListMsg() {
    WebSocketSend.getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BaseAppBar(
        leading: const SizedBox(),
        title: "通讯录",
      ),
      body: Column(
        children: [
          _buildSearch(),
          const SizedBox(height: 8),
          _buildHeadItem("assets/images/Mi.png", "新的好友", true),
          _buildHeadItem("assets/images/Uu1.png", "我的群聊", false),
          Expanded(
            child: Container(
              color: const Color(0xfff6f7fb),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4),
                itemCount: friendList?.length ?? 0,
                itemBuilder: (context, index) {
                  FriendGroupInfo groupInfo = friendList![index];
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
                          return ContactCellView(model: model);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

//Mi.png Uu1.png
  Widget _buildSearch() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xfff6f7fb), borderRadius: BorderRadius.circular(30)),
        child: const Row(
          children: [
            Icon(
              Icons.search,
              size: 16,
              color: Color(0xff999999),
            ),
            SizedBox(width: 8),
            Text(
              "搜索好友",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff999999),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeadItem(String imagePath, String title, bool showLine) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 42,
              height: 42,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 42,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (showLine) buildLineWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
