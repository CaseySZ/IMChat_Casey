import 'package:flutter/material.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';

import '../../../tool/image/custom_new_image.dart';
import '../chat_detail_page.dart';
import '../model/chat_record_model.dart';
import 'chat_item_audio_widget.dart';

class ChatItemLeftWidget extends StatelessWidget {
  final ChatRecordModel? model;
  final ChatRecordModel? afterModel;
  final Function(String imageUrl, {bool? isLocalPath})? callback;
  final GestureTapCallback? replyCallback;
  const ChatItemLeftWidget({super.key, this.model,  this.afterModel ,this.callback, this.replyCallback,});

  bool get isImg => model?.contentType == 1;

  Color? get bgColor {
    if(clickReplyModel?.relationId == model?.id && clickReplyModel != null){
      return  Colors.blue.withOpacity(0.3);
    }else if(model?.relationId?.isNotEmpty == true || model?.contentType == 0) {
      return const Color(0xfff7f7f7);
    }else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTime(),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 50, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNewImage(
                  imageUrl: model?.sendHeadImage ?? "",
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
                const SizedBox(width: 12),
                Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:  BoxDecoration(
                    color: bgColor,
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
                      if(model?.groupNo?.isNotEmpty == true && (afterModel?.sendNickName != model?.sendNickName || afterModel?.contentType != model?.contentType))
                        ...[
                          Text(model?.sendNickName ?? "", style: TextStyle(
                            color: Colors.blue.withOpacity(0.7),
                            fontSize: 14,
                          ),),
                          const SizedBox(height: 6),
                        ],
                      if(model?.relationId?.isNotEmpty == true)
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildReplyItem(),
                        ),
                      _buildContentType(),
                    ],
                  )
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
          callback?.call(model?.content ?? "");
        },
        child: CustomNewImage(
          imageUrl: model?.content ?? "",
          width: 173,
          placeholder: Container(
            width: 173,
            height: 90,
            color: const Color(0xff666666).withOpacity(0.2),
          ),
        ),
      );
    } else if (model?.contentType == 2 || model?.contentType == 3) {
      return ChatItemAudioWidget(key: ValueKey("${model?.content}${model?.id}${model?.contentType}"), model: model, isLeftStyle: true,);
    }else {
      return Flexible(
        child: RichTextWidget(
          model: model,
          isMe: false,
        ),
      );
    }
  }

  Widget _buildReplyItem() {
    return InkWell(
      onTap: replyCallback,
      child: Row(
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
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
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
