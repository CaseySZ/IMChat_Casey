import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/model/group_item_model.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';
import 'package:imchat/tool/loading/empty_error_widget.dart';

import '../../model/friend_item_info.dart';
import '../../protobuf/model/base.pb.dart';
import '../../routers/router_map.dart';
import '../../tool/image/custom_new_image.dart';
import '../../web_socket/web_message_type.dart';
import '../../web_socket/web_socket_model.dart';
import '../chat/model/chat_record_model.dart';

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyGroupPageState();
  }
}

class _MyGroupPageState extends State<MyGroupPage> {
  List<GroupItemInfo> get groupArr => GlobalData.groupList;

  @override
  void initState() {
    super.initState();
    WebSocketModel.addListener(webSocketLister);
  }

  void webSocketLister(Protocol protocol) {
    if (protocol.cmd == MessageType.groupList.responseName && protocol.isSuccess == true) {
      GlobalData.groupList = protocol.dataArr?.map((e) => GroupItemInfo.fromJson(e)).toList() ?? [];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "群组".localize,
        elevation: 0.3,
      ),
      body: groupArr.isEmpty
          ? EmptyErrorWidget(errorMsg: "暂未加入群聊哦!".localize,)
          : ListView.builder(
              itemCount: groupArr.length,
              itemBuilder: (context, index) {
                return _buildItem(
                  groupArr[index],
                );
              },
            ),
    );
  }

  Widget _buildItem(GroupItemInfo model) {
    return InkWell(
      onTap: () async {
        FriendItemInfo itemModel = FriendItemInfo.fromJson({});
        itemModel.friendNo = model.groupNo;
        itemModel.targetType = 1;
        itemModel.nickName = model.name;
        var result = await Navigator.pushNamed(context, AppRoutes.chat_detail, arguments: itemModel);
        if (result is ChatRecordModel) {
          setState(() {});
        }
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

  @override
  void dispose() {
    WebSocketModel.removeListener(webSocketLister);
    super.dispose();
  }
}
