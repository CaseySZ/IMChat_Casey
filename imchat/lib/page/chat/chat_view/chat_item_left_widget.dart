import 'package:flutter/material.dart';
import 'package:imchat/page/chat/chat_view/rich_text_widget.dart';

import '../../../tool/image/custom_new_image.dart';
import '../../../utils/screen.dart';
import '../model/chat_record_model.dart';
import 'chat_item_audio_widget.dart';

class ChatItemLeftWidget extends StatelessWidget {
  final ChatRecordModel? model;
  final Function(String imageUrl, {bool? isLocalPath})? callback;

  const ChatItemLeftWidget({super.key, this.model, this.callback});

  bool get isImg => model?.contentType == 1;

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
                _buildContentType(),
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
          width: 120,
        ),
      );
    } else if (model?.contentType == 2 || model?.contentType == 3) {
      return ChatItemAudioWidget(key: ValueKey("${model?.content}${model?.id}${model?.contentType}"), model: model, isLeftStyle: true,);
    }else {
      return Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            color: Color(0xfff7f7f7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: RichTextWidget(
            model: model,
            isMe: false,
          ),
        ),
      );
    }
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
