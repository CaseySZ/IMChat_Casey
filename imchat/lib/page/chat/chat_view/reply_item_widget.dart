import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';

import '../model/chat_record_model.dart';

class ReplyItemWidget extends StatelessWidget {
  final ChatRecordModel? replyModel;
  final Function? callback;

  const ReplyItemWidget({
    super.key,
    this.replyModel,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffececec), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Transform.rotate(
            angle: pi,
            child: Icon(
              Icons.reply,
              color: Colors.blue.withOpacity(0.8),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  replyModel?.sendNickName ?? "",
                  style: TextStyle(
                    color: Colors.blue.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                RichTextWidget(
                  model: replyModel,
                  isMe: false,
                  maxLines: 1,
                  isReplyStyle: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              callback?.call();
            },
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.close,
                color: Color(0xff999999),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
