import 'package:flutter/material.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/contact/my_group_page.dart';
import 'package:imchat/page/contact/new_friend_page.dart';
import 'package:imchat/page/contact/view/contact_cell_view.dart';
import 'package:imchat/protobuf/model/base.pb.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/utils/screen.dart';
import 'package:imchat/web_socket/web_message_type.dart';
import 'package:imchat/web_socket/web_socket_model.dart';
import 'package:imchat/web_socket/web_socket_send.dart';

import '../../model/friend_item_info.dart';
import '../add_friend/add_friend_page.dart';

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

  int friendApplyMessageTotal = 0;
  int groupApplyMessageTotal = 0;
  int msgCount(int index){
    if(index == 0) {
      return friendApplyMessageTotal;
    }else if(index == 1){
      return groupApplyMessageTotal;
    }else {
      return 0;
    }
  }
  @override
  void initState() {
    super.initState();
    WebSocketModel.addListener(messageListen);
  }

  void messageListen(Protocol protocol) {
    if (protocol.cmd == MessageType.friendList) {
      FriendItemInfo.parse(protocol.data);
      setState(() {});
    }
    if (protocol.cmd == MessageType.messageTotal.responseName && protocol.isSuccess == true) {
      friendApplyMessageTotal = protocol.data?["friendApplyMessageTotal"] ?? 0;
      groupApplyMessageTotal = protocol.data?["groupApplyMessageTotal"] ?? 0;
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
          _buildHeadItem(0, "assets/images/Mi.png", "新的好友".localize, true),
          _buildHeadItem(1, "assets/images/Uu1.png", "我的群聊".localize, false),
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
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return const AddFriendPage();
        }));
      },
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

  Widget _buildHeadItem(int index, String imagePath, String title, bool showLine) {
    return InkWell(
      onTap: () {
        if(index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewFriendPage();
          }));
        }else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyGroupPage();
          }));
        }
      },
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
                  Row(
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
                      const Spacer(),
                      if(msgCount(index) > 0)
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${msgCount(index)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                    ],
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

  @override
  void dispose() {
    WebSocketModel.removeListener(messageListen);
    super.dispose();
  }
}
