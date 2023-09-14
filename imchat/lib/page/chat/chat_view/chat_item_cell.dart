import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/config/config.dart';
import 'package:imchat/model/user_info.dart';
import 'package:imchat/page/chat/chat_view/chat_item_left_widget.dart';
import 'package:imchat/page/chat/chat_view/chat_item_right_widget.dart';
import '../../../api/im_api.dart';
import '../../../tool/image/custom_new_image.dart';
import '../model/chat_record_model.dart';

class ChatItemCell extends StatefulWidget {
  final ChatRecordModel? model;
  final Function(double, double)? callback;

  const ChatItemCell({
    super.key,
    this.model,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatItemCellState();
  }
}

class _ChatItemCellState extends State<ChatItemCell> {
  UserInfo? get useInfo => IMConfig.userInfo;

  bool get isImg => widget.model?.contentType == 1;

  bool get isMe{
    if(widget.model?.groupNo?.isNotEmpty == true){
      if(widget.model?.sendNo == useInfo?.memberNo){
        return true;
      }else {
        return false;
      }
    }
    return useInfo?.memberNo != widget.model?.receiveNo;
  }

  String get chatContent {
    if(widget.model?.contentType == 6){
      return "消息撤回";
    }
    if (widget.model?.content?.isNotEmpty == true) {
      int length = widget.model?.content?.length ?? 0;
      if (widget.model!.content!.substring(length - 1, length) == "\n") {
        return widget.model!.content!.substring(0, length - 1);
      }
      return widget.model?.content ?? "";
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
  }

  void _sendTextMessage() async {
    widget.model?.sendStatus = 0;
    setState(() {});
    String? errorDesc = await IMApi.sendMsg(
      widget.model?.sendNo ?? "",
      widget.model?.content ?? "",
      widget.model?.contentType ?? 0,
    );
    if (errorDesc?.isNotEmpty != true) {
      widget.model?.sendStatus = 1;
    } else {
      widget.model?.sendStatus = 2;
    }
    setState(() {});
  }

  void _showImageScan(String imageUrl, {bool? isLocalPath}) {
    if (imageUrl.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: (isLocalPath == true)
                  ? Image.file(
                      File(imageUrl),
                      width: MediaQuery.of(context).size.width,
                    )
                  : CustomNewImage(
                      imageUrl: imageUrl,
                      width: MediaQuery.of(context).size.width,
                    ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        double dx = details.globalPosition.dx;
        double dy = details.globalPosition.dy;
        widget.callback?.call(dx, dy);
      },
      child: _buildChatContent(),
    );
  }

  Widget _buildChatContent() {
    if ((widget.model?.contentType ?? 0) >= 6) {
      if(chatContent == "消息撤回"){
        return const SizedBox();
      }
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        alignment: Alignment.center,
        child: Text(
          chatContent,
          style: const TextStyle(
            color: Color(0xff999999),
            fontSize: 12,
          ),
        ),
      );
    }
    if (isMe) {
      return ChatItemRightWidget(
        model: widget.model,
        sendCallback: _sendTextMessage,
        callback: _showImageScan,
      );
    } else {
      return ChatItemLeftWidget(
        model: widget.model,
        callback: _showImageScan,
      );
    }
  }

}
