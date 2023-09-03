import 'package:flutter/material.dart';
import 'package:imchat/alert/home_menu_alert.dart';
import 'package:imchat/api/im_api.dart';
import 'package:imchat/config/language.dart';
import 'package:imchat/page/chat/view/msg_box_cell.dart';
import 'package:imchat/tool/appbar/base_app_bar.dart';

import '../../protobuf/model/base.pb.dart';
import '../../web_socket/web_message_type.dart';
import '../../web_socket/web_socket_model.dart';
import 'model/chat_record_model.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatMainPageState();
  }
}

class _ChatMainPageState extends State<ChatMainPage> with AutomaticKeepAliveClientMixin {
  List<ChatRecordModel>? chatArr;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WebSocketModel.addListener(webSocketLister);
  }

  void webSocketLister(Protocol protocol) {
    if (protocol.cmd == MessageType.chatBoxMessage.responseName && protocol.isSuccess == true) {
      List<ChatRecordModel> list = protocol.dataArr?.map((e) => ChatRecordModel.fromJson(e)).toList() ?? [];
      handleChatMessage(list: list);
    }
  }

  void handleChatMessage({List<ChatRecordModel>? list}) {
    chatArr ??= [];
    if (list?.isNotEmpty == true) {
      chatArr?.clear();
      chatArr?.insertAll(0, list ?? []);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BaseAppBar(
        title: "消息".localize,
        elevation: 0.3,
        leading: const SizedBox(),
        actions: [
          InkWell(
            onTap: () {
              HomeMenuAlert.show(context);
            },
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: Color(0xff666666),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: chatArr?.length ?? 0,
        itemBuilder: (context, index) {
          return MsgBoxCell(model: chatArr![index],);
        },
      ),
    );
  }


}
