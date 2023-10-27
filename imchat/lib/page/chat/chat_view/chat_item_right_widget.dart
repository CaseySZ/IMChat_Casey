import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';

import '../../../tool/image/custom_new_image.dart';
import '../model/chat_record_model.dart';
import 'chat_item_audio_widget.dart';

class ChatItemRightWidget extends StatelessWidget {
  final ChatRecordModel? model;
  final Function? sendCallback;
  final Function(String imageUrl, {bool? isLocalPath})? callback;

  const ChatItemRightWidget({super.key, this.model, this.sendCallback, this.callback});

  bool get isImg => model?.contentType == 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        children: [
          _buildTime(),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (model?.sendStatus == 0)
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: const CupertinoActivityIndicator(
                            color: Color(0xff000000),
                            radius: 8,
                          ),
                        ),
                      if (model?.sendStatus == 1)
                        InkWell(
                          onTap: () {
                            sendCallback?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: const Icon(
                              Icons.error_outline_outlined,
                              color: Color(0xfff51b1b),
                            ),
                          ),
                        ),
                      Container(
                        constraints: const BoxConstraints(minHeight: 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration:  BoxDecoration(
                          color: (model?.relationId?.isNotEmpty == true || model?.contentType == 0) ? const Color(0xddf51b1b) : null,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(model?.relationId?.isNotEmpty == true)
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildReplyItem(),
                              ),
                            _buildContentType(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                CustomNewImage(
                  imageUrl: model?.sendHeadImage,
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentType() {
    if (isImg) {
      return InkWell(
        onTap: () {
          if (model?.localPath?.isNotEmpty == true) {
            callback?.call(model?.localPath ?? "", isLocalPath: true);
          } else {
            callback?.call(model?.content ?? "");
          }
        },
        child: (model?.localPath?.isNotEmpty == true)
            ? Image.file(
                File(model!.localPath!),
                width: 173,
                height: 96,
              )
            : CustomNewImage(
                imageUrl: model?.content,
                width: 173,
                placeholder: Container(
                  width: 173,
                  height: 90,
                  color: const Color(0xff666666).withOpacity(0.2),
                ),
              ),
      );
    } else if (model?.contentType == 2 || model?.contentType == 3) {
      return ChatItemAudioWidget(key: ValueKey("${model?.content}${model?.id}${model?.contentType}"), model: model);
    } else {
      return Flexible(
        child: RichTextWidget(
          model: model,
          isMe: true,
        ),
      );
    }
  }

  Widget _buildReplyItem() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 2,
          height: 30,
          color: Colors.black.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        if(model?.relationChatRecord?.contentType == 1)
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 4),
            child:  CustomNewImage(
              imageUrl: model?.relationChatRecord?.content,
              width: 28,
              height: 28,
              radius: 2,
            ),
          )
        else if( model?.relationChatRecord?.contentType == 3)
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Image.asset(
              "assets/images/play.png",
              width: 16,
              height: 16,
            ),
          )
        else
          const SizedBox(),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model?.relationChatRecord?.sendNickName ?? "",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              model?.relationChatRecord?.contentDesc ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTime() {
    if (model?.isShowTime == true) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xfff7f7f7).withOpacity(0.42),
        ),
        child: Text(
          model?.createTime ?? "",
          style: const TextStyle(
            color: Color(0xff999393),
            fontSize: 12,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
